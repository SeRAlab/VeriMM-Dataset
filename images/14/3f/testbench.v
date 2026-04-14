`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg D;
    reg RESET;
    reg WL;
    wire BL;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .D(D),
        .RESET(RESET),
        .WL(WL),
        .BL(BL)
    );

    // Clock generation (10ns period)
    initial begin
        RESET = 0;
        forever #5 RESET = ~RESET;
    end

        task reset_dut;

        begin
            RESET = 1;
            WL = 0;
            D = 0;
            #20;
            RESET = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write 1 and Read back", test_num);
            reset_dut();


            WL = 1;
            D = 1;
            #10;


            WL = 0;
            D = 0;
            #10;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write 0 and Read back", test_num);
            reset_dut();


            WL = 1; D = 1; #10;


            WL = 1; D = 0; #10;


            WL = 0;
            #10;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify Reset sets cell to 0", test_num);
            reset_dut();


            WL = 1; D = 1; #10;


            RESET = 1;
            #10;
            RESET = 0;


            WL = 0;
            #10;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify storage is isolated when WL is low", test_num);
            reset_dut();


            WL = 1; D = 1; #10;


            WL = 0;
            #5;
            D = 0; #5;
            D = 1; #5;
            D = 0; #5;


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify Reset priority over Write (D=1)", test_num);
            reset_dut();


            RESET = 1;
            WL = 1;
            D = 1;
            #15;


            RESET = 0;
            WL = 0;
            #10;


            #1;



            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dram_cell Testbench");
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
        input expected_BL;
        begin
            if (expected_BL === (expected_BL ^ BL ^ expected_BL)) begin
                $display("PASS");
                $display("  Outputs: BL=%b",
                         BL);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BL=%b",
                         expected_BL);
                $display("  Got:      BL=%b",
                         BL);
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
        $dumpvars(0,D, RESET, WL, BL);
    end

endmodule
