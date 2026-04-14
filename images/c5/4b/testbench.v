`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg SER_IN;
    reg SH_EN;
    reg clk;
    wire [3:0] PAR_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .SER_IN(SER_IN),
        .SH_EN(SH_EN),
        .clk(clk),
        .PAR_OUT(PAR_OUT)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            SH_EN = 1;
            SER_IN = 0;
            repeat(4) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Load 4-bit 1111", test_num);
            reset_dut();

            SH_EN = 1;
            SER_IN = 1;
            repeat(4) @(posedge clk);

            #1;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Load Pattern 1011", test_num);
            reset_dut();

            SH_EN = 1;

            SER_IN = 1; @(posedge clk);
            SER_IN = 0; @(posedge clk);
            SER_IN = 1; @(posedge clk);
            SER_IN = 1; @(posedge clk);

            #1;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Verify SH_EN Hold", test_num);
            reset_dut();

            SH_EN = 1;
            SER_IN = 1;
            @(posedge clk);
            @(posedge clk);

            SH_EN = 0;
            SER_IN = 0;
            repeat(3) @(posedge clk);

            #1;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Resume Shift after Hold", test_num);
            reset_dut();


            SH_EN = 1;
            SER_IN = 1; @(posedge clk);
            SER_IN = 0; @(posedge clk);


            SH_EN = 0;
            SER_IN = 1; @(posedge clk);


            SH_EN = 1;
            SER_IN = 1; @(posedge clk);
            SER_IN = 0; @(posedge clk);

            #1;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Overflow Check", test_num);
            reset_dut();

            SH_EN = 1;
            SER_IN = 1; @(posedge clk);
            SER_IN = 0; @(posedge clk);
            SER_IN = 1; @(posedge clk);
            SER_IN = 0; @(posedge clk);
            SER_IN = 1; @(posedge clk);

            #1;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
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
        input [3:0] expected_PAR_OUT;
        begin
            if (expected_PAR_OUT === (expected_PAR_OUT ^ PAR_OUT ^ expected_PAR_OUT)) begin
                $display("PASS");
                $display("  Outputs: PAR_OUT=%h",
                         PAR_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PAR_OUT=%h",
                         expected_PAR_OUT);
                $display("  Got:      PAR_OUT=%h",
                         PAR_OUT);
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
        $dumpvars(0,SER_IN, SH_EN, clk, PAR_OUT);
    end

endmodule
