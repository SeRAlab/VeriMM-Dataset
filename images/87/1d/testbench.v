`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg rst;
    wire VGND;
    wire VNB;
    wire VPB;
    wire VPWR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .rst(rst),
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            enable = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verifying Reset State and Constant Supplies", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Verifying VPB stays low for the first 2 clock cycles when enabled", test_num);
            reset_dut();
            enable = 1;

            @(posedge clk);
            @(negedge clk);

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Verifying VPB toggles to high after 2 clock cycles", test_num);
            reset_dut();
            enable = 1;

            @(posedge clk);
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Verifying VPB toggles back to low after 4 clock cycles", test_num);
            reset_dut();
            enable = 1;

            repeat(4) @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verifying VPB and VNB are low when enable is 0", test_num);
            reset_dut();
            enable = 1;
            repeat(2) @(posedge clk);
            #2 enable = 0;
            repeat(2) @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Verifying VNB remains low throughout multiple cycles", test_num);
            reset_dut();
            enable = 1;
            repeat(10) @(posedge clk);
            #2;

            if (VNB === 1'b0) begin
                #1;

                check_outputs(VGND, 1'b0, VPB, VPWR);
            end else begin
                $display("VNB Failure logic detected");
                fail_count = fail_count + 1;
            end
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
        input expected_VGND;
        input expected_VNB;
        input expected_VPB;
        input expected_VPWR;
        begin
            if (expected_VGND === (expected_VGND ^ VGND ^ expected_VGND) &&
                expected_VNB === (expected_VNB ^ VNB ^ expected_VNB) &&
                expected_VPB === (expected_VPB ^ VPB ^ expected_VPB) &&
                expected_VPWR === (expected_VPWR ^ VPWR ^ expected_VPWR)) begin
                $display("PASS");
                $display("  Outputs: VGND=%b, VNB=%b, VPB=%b, VPWR=%b",
                         VGND, VNB, VPB, VPWR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: VGND=%b, VNB=%b, VPB=%b, VPWR=%b",
                         expected_VGND, expected_VNB, expected_VPB, expected_VPWR);
                $display("  Got:      VGND=%b, VNB=%b, VPB=%b, VPWR=%b",
                         VGND, VNB, VPB, VPWR);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, enable, rst, VGND, VNB, VPB, VPWR);
    end

endmodule
