`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] ams;
    reg amsen;
    reg [9:0] eg_pure_in;
    reg [6:0] lfo_mod;
    reg ssg_inv;
    reg [6:0] tl;
    wire [9:0] eg_limited;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ams(ams),
        .amsen(amsen),
        .eg_pure_in(eg_pure_in),
        .lfo_mod(lfo_mod),
        .ssg_inv(ssg_inv),
        .tl(tl),
        .eg_limited(eg_limited)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            ams = 2'b00;
            amsen = 1'b0;
            eg_pure_in = 10'd0;
            lfo_mod = 7'd0;
            ssg_inv = 1'b0;
            tl = 7'd0;
            #1;

            check_outputs(10'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pure Envelope Pass-through", test_num);
            ams = 2'b00;
            amsen = 1'b0;
            eg_pure_in = 10'd512;
            lfo_mod = 7'd0;
            ssg_inv = 1'b0;
            tl = 7'd0;
            #1;

            check_outputs(10'd512);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Total Level Effect", test_num);
            ams = 2'b00;
            amsen = 1'b0;
            eg_pure_in = 10'd100;
            lfo_mod = 7'd0;
            ssg_inv = 1'b0;
            tl = 7'd10;
            #1;

            check_outputs(10'd180);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: AMS Modulation Enable", test_num);
            ams = 2'b10;
            amsen = 1'b1;
            eg_pure_in = 10'd0;
            lfo_mod = 7'd64;
            ssg_inv = 1'b0;
            tl = 7'd0;
            #1;

            check_outputs(10'd32);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Saturation/Clipping", test_num);
            ams = 2'b00;
            amsen = 1'b0;
            eg_pure_in = 10'd1000;
            lfo_mod = 7'd0;
            ssg_inv = 1'b0;
            tl = 7'd127;
            #1;

            check_outputs(10'h3FF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SSG Inversion", test_num);
            ams = 2'b00;
            amsen = 1'b0;
            eg_pure_in = 10'd0;
            lfo_mod = 7'd0;
            ssg_inv = 1'b1;
            tl = 7'd0;
            #1;

            check_outputs(10'h3FF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Combined Modulation", test_num);
            ams = 2'b11;
            amsen = 1'b1;
            eg_pure_in = 10'd100;
            lfo_mod = 7'd20;
            ssg_inv = 1'b0;
            tl = 7'd5;
            #1;

            check_outputs(10'd160);
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
        input [9:0] expected_eg_limited;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_eg_limited === (expected_eg_limited ^ eg_limited ^ expected_eg_limited)) begin
                $display("PASS");
                $display("  Outputs: eg_limited=%h",
                         eg_limited);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: eg_limited=%h",
                         expected_eg_limited);
                $display("  Got:      eg_limited=%h",
                         eg_limited);
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
