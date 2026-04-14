`timescale 1ns/1ps

module piso_shift_reg_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg LOAD;
    reg [7:0] PARALLEL_IN;
    wire SERIAL_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    piso_shift_reg dut (
        .CLK(CLK),
        .LOAD(LOAD),
        .PARALLEL_IN(PARALLEL_IN),
        .SERIAL_OUT(SERIAL_OUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            LOAD = 0;
            PARALLEL_IN = 8'h00;
            @(posedge CLK);
            LOAD = 1;
            PARALLEL_IN = 8'h00;
            @(posedge CLK);
            #1;
            LOAD = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Load 0xAA (10101010), check bit 7", test_num);
            reset_dut();
            PARALLEL_IN = 8'b10101010;
            LOAD = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Load 0xAA, shift 1, check bit 6", test_num);
            reset_dut();
            PARALLEL_IN = 8'b10101010;
            LOAD = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Load 0xCC (11001100), shift 2, check bit 5", test_num);
            reset_dut();
            PARALLEL_IN = 8'b11001100;
            LOAD = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;
            repeat(2) @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Load 0xF0 (11110000), shift 3, check bit 4", test_num);
            reset_dut();
            PARALLEL_IN = 8'b11110000;
            LOAD = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;
            repeat(3) @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Load 0x55 (01010101), shift 7, check bit 0", test_num);
            reset_dut();
            PARALLEL_IN = 8'b01010101;
            LOAD = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;
            repeat(7) @(posedge CLK);
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
        $display("piso_shift_reg Testbench");
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
        input expected_SERIAL_OUT;
        begin
            if (expected_SERIAL_OUT === (expected_SERIAL_OUT ^ SERIAL_OUT ^ expected_SERIAL_OUT)) begin
                $display("PASS");
                $display("  Outputs: SERIAL_OUT=%b",
                         SERIAL_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SERIAL_OUT=%b",
                         expected_SERIAL_OUT);
                $display("  Got:      SERIAL_OUT=%b",
                         SERIAL_OUT);
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
        $dumpvars(0,CLK, LOAD, PARALLEL_IN, SERIAL_OUT);
    end

endmodule
