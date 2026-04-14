`timescale 1ns/1ps

module parallel_to_serial_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [7:0] DATA_IN;
    reg LOAD;
    reg RST;
    reg SHIFT_EN;
    wire DATA_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    parallel_to_serial dut (
        .CLK(CLK),
        .DATA_IN(DATA_IN),
        .LOAD(LOAD),
        .RST(RST),
        .SHIFT_EN(SHIFT_EN),
        .DATA_OUT(DATA_OUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            LOAD = 0;
            SHIFT_EN = 0;
            DATA_IN = 0;
            #12;
            RST = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Checking Reset State...");
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Load 0x01 and shift once...");
            reset_dut();
            DATA_IN = 8'h01;
            LOAD = 1;
            @(posedge CLK); #1;
            LOAD = 0;
            SHIFT_EN = 1;
            @(posedge CLK); #1;
            SHIFT_EN = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Load 0xAA and check first serial bit...");
            reset_dut();
            DATA_IN = 8'hAA;
            LOAD = 1;
            @(posedge CLK); #1;
            LOAD = 0;
            SHIFT_EN = 1;
            @(posedge CLK); #1;
            SHIFT_EN = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Load 0xAA and check second serial bit...");
            reset_dut();
            DATA_IN = 8'hAA;
            LOAD = 1;
            @(posedge CLK); #1;
            LOAD = 0;
            SHIFT_EN = 1;
            repeat(2) @(posedge CLK); #1;
            SHIFT_EN = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Load 0x80 and shift 8 times to check MSB...");
            reset_dut();
            DATA_IN = 8'h80;
            LOAD = 1;
            @(posedge CLK); #1;
            LOAD = 0;
            SHIFT_EN = 1;
            repeat(8) @(posedge CLK); #1;
            SHIFT_EN = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Verify SHIFT_EN inhibition...");
            reset_dut();
            DATA_IN = 8'hFF;
            LOAD = 1;
            @(posedge CLK); #1;
            LOAD = 0;
            SHIFT_EN = 0;
            repeat(4) @(posedge CLK); #1;
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
        $display("parallel_to_serial Testbench");
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
        $dumpvars(0,CLK, DATA_IN, LOAD, RST, SHIFT_EN, DATA_OUT);
    end

endmodule
