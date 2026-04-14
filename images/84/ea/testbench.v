`timescale 1ns/1ps

module shift_register_32bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [31:0] parallel_in;
    reg rst_n;
    reg shift;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_32bit dut (
        .clk(clk),
        .load(load),
        .parallel_in(parallel_in),
        .rst_n(rst_n),
        .shift(shift),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            load = 0;
            shift = 0;
            parallel_in = 32'h0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Load Parallel Data (LSB=0)", test_num);
            reset_dut();
            parallel_in = 32'hAAAA_AAA0;
            load = 1;
            @(posedge clk);
            #1 load = 0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Load Parallel Data (LSB=1)", test_num);
            reset_dut();
            parallel_in = 32'h5555_5551;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Shift Right Single Step", test_num);
            reset_dut();
            parallel_in = 32'h0000_0002;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            shift = 1;
            @(posedge clk);
            #1 shift = 0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Full Shift Through", test_num);
            reset_dut();
            parallel_in = 32'h8000_0000;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            shift = 1;
            repeat(31) @(posedge clk);
            #1 shift = 0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Shift Out All Data", test_num);
            reset_dut();
            parallel_in = 32'hFFFF_FFFF;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            shift = 1;
            repeat(32) @(posedge clk);
            #1 shift = 0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Load Priority Check", test_num);
            reset_dut();
            parallel_in = 32'h1234_5678;
            load = 1;
            shift = 1;
            @(posedge clk);
            #1 load = 0; shift = 0;


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
        $display("shift_register_32bit Testbench");
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
        $dumpvars(0,clk, load, parallel_in, rst_n, shift, serial_out);
    end

endmodule
