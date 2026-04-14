`timescale 1ns/1ps

module sd_card_controller_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr;
    reg clk;
    reg [15:0] data_in;
    reg reset;
    reg rw;
    wire [15:0] data_out;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sd_card_controller dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .rw(rw),
        .data_out(data_out),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            addr = 4'h0;
            rw = 0;
            data_in = 16'h0000;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Basic Write/Read Address 0", test_num);
            reset_dut();


            addr = 4'h0;
            data_in = 16'hABCD;
            rw = 1;
            @(posedge clk);


            rw = 0;
            addr = 4'h0;
            @(posedge clk);


            wait(ready == 1);
            #1;

            check_outputs(16'hABCD, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Write/Read Address 15", test_num);
            reset_dut();


            addr = 4'hF;
            data_in = 16'h55AA;
            rw = 1;
            @(posedge clk);


            rw = 0;
            addr = 4'hF;
            @(posedge clk);

            wait(ready == 1);
            #1;

            check_outputs(16'h55AA, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Overwrite Data", test_num);
            reset_dut();


            addr = 4'h5;
            data_in = 16'h1111;
            rw = 1;
            @(posedge clk);


            data_in = 16'hFFFF;
            rw = 1;
            @(posedge clk);


            rw = 0;
            @(posedge clk);

            wait(ready == 1);
            #1;

            check_outputs(16'hFFFF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Sequential Write/Read", test_num);
            reset_dut();


            addr = 4'h1; data_in = 16'h1234; rw = 1;
            @(posedge clk);


            addr = 4'h2; data_in = 16'h5678; rw = 1;
            @(posedge clk);


            addr = 4'h1; rw = 0;
            @(posedge clk);


            addr = 4'h2; rw = 0;
            @(posedge clk);

            wait(ready == 1);
            #1;

            check_outputs(16'h5678, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Read after reset", test_num);
            reset_dut();

            addr = 4'hA;
            rw = 0;
            @(posedge clk);

            wait(ready == 1);

            #1;


            check_outputs(16'h0000, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sd_card_controller Testbench");
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
        input [15:0] expected_data_out;
        input expected_ready;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, ready=%b",
                         data_out, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, ready=%b",
                         expected_data_out, expected_ready);
                $display("  Got:      data_out=%h, ready=%b",
                         data_out, ready);
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
        $dumpvars(0,addr, clk, data_in, reset, rw, data_out, ready);
    end

endmodule
