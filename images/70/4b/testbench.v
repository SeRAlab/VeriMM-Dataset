`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg mux_select;
    reg [7:0] tdata0;
    reg [7:0] tdata1;
    reg tlast0;
    reg tlast1;
    reg tready;
    reg tvalid0;
    reg tvalid1;
    wire [7:0] tdata;
    wire tlast;
    wire tready0;
    wire tready1;
    wire tvalid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .mux_select(mux_select),
        .tdata0(tdata0),
        .tdata1(tdata1),
        .tlast0(tlast0),
        .tlast1(tlast1),
        .tready(tready),
        .tvalid0(tvalid0),
        .tvalid1(tvalid1),
        .tdata(tdata),
        .tlast(tlast),
        .tready0(tready0),
        .tready1(tready1),
        .tvalid(tvalid)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select Port 0, valid data, ready from downstream", test_num);
            mux_select = 1'b0;
            tdata0 = 8'hA1; tvalid0 = 1'b1; tlast0 = 1'b0;
            tdata1 = 8'hB1; tvalid1 = 1'b1; tlast1 = 1'b0;
            tready = 1'b1;

            #1;


            check_outputs(8'hA1, 1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select Port 1, valid data, ready from downstream", test_num);
            mux_select = 1'b1;
            tdata0 = 8'hA2; tvalid0 = 1'b1; tlast0 = 1'b0;
            tdata1 = 8'hB2; tvalid1 = 1'b1; tlast1 = 1'b0;
            tready = 1'b1;

            #1;


            check_outputs(8'hB2, 1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select Port 0, backpressure from downstream", test_num);
            mux_select = 1'b0;
            tdata0 = 8'hA3; tvalid0 = 1'b1; tlast0 = 1'b0;
            tdata1 = 8'hB3; tvalid1 = 1'b1; tlast1 = 1'b1;
            tready = 1'b0;

            #1;


            check_outputs(8'hA3, 1'b0, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select Port 1, backpressure from downstream", test_num);
            mux_select = 1'b1;
            tdata0 = 8'hA4; tvalid0 = 1'b1; tlast0 = 1'b1;
            tdata1 = 8'hB4; tvalid1 = 1'b1; tlast1 = 1'b0;
            tready = 1'b0;

            #1;


            check_outputs(8'hB4, 1'b0, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select Port 0, check tlast propagation", test_num);
            mux_select = 1'b0;
            tdata0 = 8'hA5; tvalid0 = 1'b1; tlast0 = 1'b1;
            tdata1 = 8'hB5; tvalid1 = 1'b1; tlast1 = 1'b0;
            tready = 1'b1;

            #1;


            check_outputs(8'hA5, 1'b1, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select Port 1, check tlast propagation", test_num);
            mux_select = 1'b1;
            tdata0 = 8'hA6; tvalid0 = 1'b1; tlast0 = 1'b0;
            tdata1 = 8'hB6; tvalid1 = 1'b1; tlast1 = 1'b1;
            tready = 1'b1;

            #1;


            check_outputs(8'hB6, 1'b1, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select Port 0, Port 0 not valid", test_num);
            mux_select = 1'b0;
            tdata0 = 8'hA7; tvalid0 = 1'b0; tlast0 = 1'b0;
            tdata1 = 8'hB7; tvalid1 = 1'b1; tlast1 = 1'b0;
            tready = 1'b1;

            #1;


            check_outputs(8'hA7, 1'b0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select Port 1, Port 1 not valid", test_num);
            mux_select = 1'b1;
            tdata0 = 8'hA8; tvalid0 = 1'b1; tlast0 = 1'b0;
            tdata1 = 8'hB8; tvalid1 = 1'b0; tlast1 = 1'b0;
            tready = 1'b1;

            #1;


            check_outputs(8'hB8, 1'b0, 1'b0, 1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [7:0] expected_tdata;
        input expected_tlast;
        input expected_tready0;
        input expected_tready1;
        input expected_tvalid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_tdata === (expected_tdata ^ tdata ^ expected_tdata) &&
                expected_tlast === (expected_tlast ^ tlast ^ expected_tlast) &&
                expected_tready0 === (expected_tready0 ^ tready0 ^ expected_tready0) &&
                expected_tready1 === (expected_tready1 ^ tready1 ^ expected_tready1) &&
                expected_tvalid === (expected_tvalid ^ tvalid ^ expected_tvalid)) begin
                $display("PASS");
                $display("  Outputs: tdata=%h, tlast=%b, tready0=%b, tready1=%b, tvalid=%b",
                         tdata, tlast, tready0, tready1, tvalid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tdata=%h, tlast=%b, tready0=%b, tready1=%b, tvalid=%b",
                         expected_tdata, expected_tlast, expected_tready0, expected_tready1, expected_tvalid);
                $display("  Got:      tdata=%h, tlast=%b, tready0=%b, tready1=%b, tvalid=%b",
                         tdata, tlast, tready0, tready1, tvalid);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

endmodule
