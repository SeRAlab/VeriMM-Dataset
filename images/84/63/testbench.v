`timescale 1ns/1ps

module piso_shift_register_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [7:0] DATA_IN;
    reg LOAD;
    reg RESET;
    wire DATA_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    piso_shift_register dut (
        .CLK(CLK),
        .DATA_IN(DATA_IN),
        .LOAD(LOAD),
        .RESET(RESET),
        .DATA_OUT(DATA_OUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RESET = 1;
            LOAD = 0;
            DATA_IN = 8'b0;
            #15;
            RESET = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Load 8'hA5 and shift 7 times...");
            reset_dut();
            @(negedge CLK);
            LOAD = 1;
            DATA_IN = 8'b10100101;
            @(negedge CLK);
            LOAD = 0;
            repeat (7) @(negedge CLK);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Load 8'hF0 and check bit 0...");
            reset_dut();
            @(negedge CLK);
            LOAD = 1;
            DATA_IN = 8'b11110000;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Check asynchronous reset during operation...");
            reset_dut();
            @(negedge CLK);
            LOAD = 1;
            DATA_IN = 8'hFF;
            @(negedge CLK);
            LOAD = 0;
            RESET = 1;
            #2;
            #1;

            check_outputs(1'b0);
            RESET = 0;
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Verify zero-fill during right shift...");
            reset_dut();
            @(negedge CLK);
            LOAD = 1;
            DATA_IN = 8'b00000001;
            @(negedge CLK);
            LOAD = 0;
            @(negedge CLK);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Reload data during shifting...");
            reset_dut();
            @(negedge CLK);
            LOAD = 1;
            DATA_IN = 8'hAA;
            @(negedge CLK);
            LOAD = 0;
            repeat(2) @(negedge CLK);
            LOAD = 1;
            DATA_IN = 8'h55;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("piso_shift_register Testbench");
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
        input expected_DATA_OUT;
        begin
            if (expected_DATA_OUT === (expected_DATA_OUT ^ DATA_OUT ^ expected_DATA_OUT)) begin
                $display("PASS");
                $display("  Outputs: DATA_OUT=%b",
                         DATA_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DATA_OUT=%b",
                         expected_DATA_OUT);
                $display("  Got:      DATA_OUT=%b",
                         DATA_OUT);
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
        $dumpvars(0,CLK, DATA_IN, LOAD, RESET, DATA_OUT);
    end

endmodule
