`timescale 1ns/1ps

module PISO_Shift_Register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [7:0] parallel_in;
    wire done;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PISO_Shift_Register dut (
        .clk(clk),
        .load(load),
        .parallel_in(parallel_in),
        .done(done),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            load = 0;
            parallel_in = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Running Testcase %03d: All Zeros (0x00)", test_num);
            parallel_in = 8'h00;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            repeat(7) @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Running Testcase %03d: All Ones (0xFF)", test_num);
            parallel_in = 8'hFF;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            repeat(7) @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Running Testcase %03d: Pattern 0xAA", test_num);
            parallel_in = 8'hAA;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            repeat(7) @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Running Testcase %03d: Pattern 0x55", test_num);
            parallel_in = 8'h55;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            repeat(7) @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Running Testcase %03d: MSB only (0x80)", test_num);
            parallel_in = 8'h80;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            repeat(7) @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Running Testcase %03d: LSB only (0x01)", test_num);
            parallel_in = 8'h01;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            repeat(7) @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Running Testcase %03d: Pattern 0x3C", test_num);
            parallel_in = 8'h3C;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            repeat(7) @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Running Testcase %03d: Pattern 0xC3", test_num);
            parallel_in = 8'hC3;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            repeat(7) @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("PISO_Shift_Register Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input expected_done;
        input expected_serial_out;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: done=%b, serial_out=%b",
                         done, serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, serial_out=%b",
                         expected_done, expected_serial_out);
                $display("  Got:      done=%b, serial_out=%b",
                         done, serial_out);
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
        $dumpvars(0,clk, load, parallel_in, done, serial_out);
    end

endmodule
