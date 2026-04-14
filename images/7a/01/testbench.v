`timescale 1ns/1ps

module shift_register_4bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg load;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_4bit dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
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
            load = 1;
            data_in = 4'b0000;
            @(posedge clk);
            load = 0;
            data_in = 4'b0000;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Parallel Load 4'b1011", test_num);
            @(posedge clk);
            load = 1;
            data_in = 4'b1011;
            @(posedge clk);
            load = 0;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Load 4'b1000 and shift right once", test_num);
            @(posedge clk);
            load = 1;
            data_in = 4'b1000;
            @(posedge clk);
            load = 0;
            @(posedge clk);
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Load 4'b1100 and shift right twice", test_num);
            @(posedge clk);
            load = 1;
            data_in = 4'b1100;
            @(posedge clk);
            load = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Load 4'b1111 and shift right four times", test_num);
            @(posedge clk);
            load = 1;
            data_in = 4'b1111;
            @(posedge clk);
            load = 0;
            repeat(4) @(posedge clk);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Load 4'b0101, then load 4'b1110 immediately", test_num);
            @(posedge clk);
            load = 1;
            data_in = 4'b0101;
            @(posedge clk);
            data_in = 4'b1110;
            @(posedge clk);
            load = 0;
            #1;

            check_outputs(4'b1110);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register_4bit Testbench");
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
        input [3:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, load, data_out);
    end

endmodule
