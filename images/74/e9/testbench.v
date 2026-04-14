`timescale 1ns/1ps

module shift_register_with_parallel_load_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg load;
    reg reset;
    reg shift;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_with_parallel_load dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .reset(reset),
        .shift(shift),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset <= 1;
            load <= 0;
            shift <= 0;
            data_in <= 16'h0;
            @(posedge clk);
            reset <= 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Synchronous Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Parallel Load (0xABCD)", test_num);
            reset_dut();
            @(posedge clk);
            load <= 1;
            data_in <= 16'hABCD;
            @(posedge clk);
            load <= 0;
            #1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift Left 1-bit (0x5555 -> 0xAAAA)", test_num);
            reset_dut();
            @(posedge clk);
            load <= 1;
            data_in <= 16'h5555;
            @(posedge clk);
            load <= 0;
            shift <= 1;
            @(posedge clk);
            shift <= 0;
            #1;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift Left Multiple bits (0x0001 -> 0x0010)", test_num);
            reset_dut();
            @(posedge clk);
            load <= 1;
            data_in <= 16'h0001;
            @(posedge clk);
            load <= 0;
            shift <= 1;
            repeat(4) @(posedge clk);
            shift <= 0;
            #1;
            #1;

            check_outputs(16'h0010);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift Left into 0s (0xFF00 -> 0x0000)", test_num);
            reset_dut();
            @(posedge clk);
            load <= 1;
            data_in <= 16'hFF00;
            @(posedge clk);
            load <= 0;
            shift <= 1;
            repeat(16) @(posedge clk);
            shift <= 0;
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Priority - Load over Shift", test_num);
            reset_dut();
            @(posedge clk);
            load <= 1;
            shift <= 1;
            data_in <= 16'h1234;
            @(posedge clk);
            load <= 0;
            shift <= 0;
            #1;

            #1;


            check_outputs(16'h1234);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Priority - Reset over Load and Shift", test_num);
            reset_dut();

            @(posedge clk);
            load <= 1;
            data_in <= 16'hFFFF;
            @(posedge clk);

            reset <= 1;
            load <= 1;
            shift <= 1;
            data_in <= 16'h1234;
            @(posedge clk);
            reset <= 0;
            load <= 0;
            shift <= 0;
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register_with_parallel_load Testbench");
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
        input [15:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, load, reset, shift, data_out);
    end

endmodule
