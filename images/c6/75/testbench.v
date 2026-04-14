`timescale 1ns/1ps

module supply_signals_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    wire VGND;
    wire VNB;
    wire VPB;
    wire VPWR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    supply_signals dut (
        .clk(clk),
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



            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Initial Update Check", test_num);
            reset_dut();



            #1;




            check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Stability Check over multiple cycles", test_num);
            reset_dut();


            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Long duration supply stability check", test_num);
            reset_dut();


            repeat(20) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("supply_signals Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        
        
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
        $dumpvars(0,clk, VGND, VNB, VPB, VPWR);
    end

endmodule
