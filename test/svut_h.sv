// Copyright 2017 Damien Pretet ThotIP
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


`ifndef INFO
`define INFO(msg) \
    $display("INFO:    [%g]: %s", $time, msg)
`endif

`ifndef WARNING
`define WARNING(msg) \
    $display("WARNING: [%g]: %s", $time, msg)
`endif

`ifndef ERROR
`define ERROR(msg) \
    $display("ERROR:   [%g]: %s", $time, msg)
`endif

`ifndef SVUT_SETUP
`define SVUT_SETUP \
    integer svut_timeout = 0; \
    integer svut_timeout_max = 100000; \
    integer svut_error = 0; \
    integer svut_nb_test = 0; \
    integer svut_nb_test_success = 0;
`endif

`ifndef SVUT_SET_TIMEOUT
`define SVUT_SET_TIMEOUT(value) \
    svut_timeout_max = value
`endif

`ifndef FAIL_IF
`define FAIL_IF(exp) \
    if (exp) \
        svut_error = svut_error + 1
`endif

`ifndef FAIL_IF_NOT
`define FAIL_IF_NOT(exp) \
    if (!exp) \
        svut_error = svut_error + 1
`endif

`ifndef FAIL_IF_EQUAL
`define FAIL_IF_EQUAL(a,b) \
    if (a === b) \
        svut_error = svut_error + 1
`endif

`ifndef FAIL_IF_NOT_EQUAL
`define FAIL_IF_NOT_EQUAL(a,b) \
    if (a !== b) \
        svut_error = svut_error + 1
`endif

`define UNIT_TESTS \
    task automatic run(); \
    begin

`define UNIT_TEST(TESTNAME) \
        setup(); \
        svut_error = 0; \
        svut_timeout = 0; \
        svut_nb_test = svut_nb_test + 1; \
        fork : TESTNAME \
            begin \

`define UNIT_TEST_END \
                disable TESTNAME; \
            end \
            begin \
                if (svut_timeout_max != 0) begin \
                    while (svut_timeout < svut_timeout_max) begin \
                        svut_timeout = svut_timeout + 1; \
                        #1; \
                    end \
                    $display("ERROR: Timeout reached @ %g!", $time); \
                    svut_error = svut_error + 1; \
                    disable TESTNAME; \
                end \
            end \
        join \
        #0; \
        teardown(); \
        if (svut_error == 0) \
            svut_nb_test_success = svut_nb_test_success + 1; \
        else \
            $display("ERROR: test fail");

`define UNIT_TESTS_END \
    end \
    endtask \
    initial begin\
        run(); \
        $display("INFO: Testsuite finished to run @ %g", $time); \
        $display("INFO: Successful tests: %3d / %3d", svut_nb_test_success, svut_nb_test); \
        $finish(); \
    end

