`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ap_start;
    reg [7:0] jet_muPt_V;
    reg [4:0] jet_tk13DIP_V;
    wire ap_done;
    wire ap_idle;
    wire ap_ready;
    wire jet_d_V;
    wire jet_d_V_ap_vld;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ap_start(ap_start),
        .jet_muPt_V(jet_muPt_V),
        .jet_tk13DIP_V(jet_tk13DIP_V),
        .ap_done(ap_done),
        .ap_idle(ap_idle),
        .ap_ready(ap_ready),
        .jet_d_V(jet_d_V),
        .jet_d_V_ap_vld(jet_d_V_ap_vld)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: ap_start = 0, check idle status and invalid outputs", test_num);
        ap_start = 1'b0;
        jet_muPt_V = 8'hAA;
        jet_tk13DIP_V = 5'h05;







        #1;








        check_outputs(1'b0, 1'b1, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: ap_start = 1, check active status and valid outputs", test_num);
        ap_start = 1'b1;
        jet_muPt_V = 8'h55;
        jet_tk13DIP_V = 5'h10;







        #1;








        check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Varying data inputs while ap_start is high", test_num);
        ap_start = 1'b1;
        jet_muPt_V = 8'hFF;
        jet_tk13DIP_V = 5'h1F;


        #1;



        check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Transition ap_start from 1 to 0", test_num);
        ap_start = 1'b1;
        #10;
        ap_start = 1'b0;
        jet_muPt_V = 8'h00;
        jet_tk13DIP_V = 5'h00;


        #1;



        check_outputs(1'b0, 1'b1, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Randomized data inputs", test_num);
        ap_start = 1'b1;
        jet_muPt_V = $urandom_range(0, 255);
        jet_tk13DIP_V = $urandom_range(0, 31);


        #1;



        check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b1);
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
        input expected_ap_done;
        input expected_ap_idle;
        input expected_ap_ready;
        input expected_jet_d_V;
        input expected_jet_d_V_ap_vld;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ap_done === (expected_ap_done ^ ap_done ^ expected_ap_done) &&
                expected_ap_idle === (expected_ap_idle ^ ap_idle ^ expected_ap_idle) &&
                expected_ap_ready === (expected_ap_ready ^ ap_ready ^ expected_ap_ready) &&
                expected_jet_d_V === (expected_jet_d_V ^ jet_d_V ^ expected_jet_d_V) &&
                expected_jet_d_V_ap_vld === (expected_jet_d_V_ap_vld ^ jet_d_V_ap_vld ^ expected_jet_d_V_ap_vld)) begin
                $display("PASS");
                $display("  Outputs: ap_done=%b, ap_idle=%b, ap_ready=%b, jet_d_V=%b, jet_d_V_ap_vld=%b",
                         ap_done, ap_idle, ap_ready, jet_d_V, jet_d_V_ap_vld);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ap_done=%b, ap_idle=%b, ap_ready=%b, jet_d_V=%b, jet_d_V_ap_vld=%b",
                         expected_ap_done, expected_ap_idle, expected_ap_ready, expected_jet_d_V, expected_jet_d_V_ap_vld);
                $display("  Got:      ap_done=%b, ap_idle=%b, ap_ready=%b, jet_d_V=%b, jet_d_V_ap_vld=%b",
                         ap_done, ap_idle, ap_ready, jet_d_V, jet_d_V_ap_vld);
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
