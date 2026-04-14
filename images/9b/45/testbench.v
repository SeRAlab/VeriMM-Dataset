`timescale 1ns/1ps

module ShiftRegister_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [7:0] parallel_in;
    reg shift_en;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ShiftRegister dut (
        .clk(clk),
        .load(load),
        .parallel_in(parallel_in),
        .shift_en(shift_en),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            load = 0;
            shift_en = 0;
            parallel_in = 8'h00;

            load = 1;
            parallel_in = 8'h00;
            @(negedge clk);
            load = 0;
            $display("DUT Initialized");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Parallel Load MSB=1", test_num);
            @(negedge clk);
            load = 1;
            parallel_in = 8'b10101010;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Parallel Load MSB=0", test_num);
            @(negedge clk);
            load = 1;
            parallel_in = 8'b01010101;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Single Shift Left", test_num);
            @(negedge clk);
            load = 1;
            parallel_in = 8'b01000000;
            @(negedge clk);
            load = 0;
            shift_en = 1;
            @(negedge clk);
            shift_en = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Shift Left 7 times", test_num);
            @(negedge clk);
            load = 1;
            parallel_in = 8'b00000001;
            @(negedge clk);
            load = 0;
            shift_en = 1;
            for (i = 0; i < 7; i = i + 1) begin
                @(negedge clk);
            end
            shift_en = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Data Retention (shift_en=0)", test_num);
            @(negedge clk);
            load = 1;
            parallel_in = 8'b10000000;
            @(negedge clk);
            load = 0;
            shift_en = 0;
            repeat(5) @(negedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Shift Fill with Zero check", test_num);
            @(negedge clk);
            load = 1;
            parallel_in = 8'hFF;
            @(negedge clk);
            load = 0;
            shift_en = 1;
            for (i = 0; i < 8; i = i + 1) begin
                @(negedge clk);
            end
            shift_en = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Load Priority Test", test_num);
            @(negedge clk);
            load = 1;
            parallel_in = 8'hAA;
            shift_en = 1;
            @(negedge clk);


            load = 0;
            shift_en = 0;
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
        $display("ShiftRegister Testbench");
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
        input expected_serial_out;
        begin
            if (expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: serial_out=%b",
                         serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: serial_out=%b",
                         expected_serial_out);
                $display("  Got:      serial_out=%b",
                         serial_out);
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
        $dumpvars(0,clk, load, parallel_in, shift_en, serial_out);
    end

endmodule
