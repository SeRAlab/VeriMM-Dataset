`timescale 1ns/1ps

module shift_reg_4bit_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RST;
    reg SI;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_reg_4bit dut (
        .CLK(CLK),
        .RST(RST),
        .SI(SI),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            @(negedge CLK);
            RST = 1;
            SI = 0;
            @(posedge CLK);
            #1;
            RST = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Synchronous Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Single Shift (SI=1)", test_num);
            reset_dut();
            @(negedge CLK);
            SI = 1;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(4'h8);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Fill Register with 1s", test_num);
            reset_dut();
            repeat (4) begin
                @(negedge CLK);
                SI = 1;
                @(posedge CLK);
            end
            #1;

            #1;


            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Sequence Shift (1-0-1-1)", test_num);
            reset_dut();

            @(negedge CLK); SI = 1; @(posedge CLK);

            @(negedge CLK); SI = 0; @(posedge CLK);

            @(negedge CLK); SI = 1; @(posedge CLK);

            @(negedge CLK); SI = 1; @(posedge CLK);
            #1;

            #1;


            check_outputs(4'hD);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Reset during operation", test_num);
            reset_dut();

            @(negedge CLK); SI = 1; @(posedge CLK);
            @(negedge CLK); SI = 1; @(posedge CLK);

            @(negedge CLK);
            RST = 1;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Full shift out of data", test_num);
            reset_dut();

            @(negedge CLK); SI = 1; @(posedge CLK);

            repeat(3) begin
                @(negedge CLK); SI = 0; @(posedge CLK);
            end
            #1;

            #1;


            check_outputs(4'h1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_reg_4bit Testbench");
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
        input [3:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,CLK, RST, SI, Q);
    end

endmodule
