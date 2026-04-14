`timescale 1ns/1ps

module i2c_master_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg start;
    reg stop;
    wire done;
    wire scl;
    wire sda;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    i2c_master dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .start(start),
        .stop(stop),
        .done(done),
        .scl(scl),
        .sda(sda)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            stop = 0;
            data_in = 8'h00;
            repeat (2) @(posedge clk);
            #2 rst = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Sending 0xAA", test_num);
            reset_dut();


            data_in = 8'hAA;
            start = 1;
            @(posedge clk);
            #1 start = 0;


            wait(done == 1);
            @(posedge clk);


            stop = 1;
            @(posedge clk);
            #1 stop = 0;


            wait(done == 1);
            repeat (5) @(posedge clk);


            #1;



            check_outputs(1, 1, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Sending 0x55", test_num);
            reset_dut();

            data_in = 8'h55;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done == 1);
            @(posedge clk);

            stop = 1;
            @(posedge clk);
            #1 stop = 0;

            wait(done == 1);
            repeat (5) @(posedge clk);

            #1;


            check_outputs(1, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Sending 0x00", test_num);
            reset_dut();

            data_in = 8'h00;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done == 1);
            @(posedge clk);

            stop = 1;
            @(posedge clk);
            #1 stop = 0;

            wait(done == 1);
            repeat (5) @(posedge clk);

            #1;


            check_outputs(1, 1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Sending 0xFF", test_num);
            reset_dut();

            data_in = 8'hFF;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done == 1);
            @(posedge clk);

            stop = 1;
            @(posedge clk);
            #1 stop = 0;

            wait(done == 1);
            repeat (5) @(posedge clk);

            #1;


            check_outputs(1, 1, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("i2c_master Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_scl;
        input expected_sda;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_scl === (expected_scl ^ scl ^ expected_scl) &&
                expected_sda === (expected_sda ^ sda ^ expected_sda)) begin
                $display("PASS");
                $display("  Outputs: done=%b, scl=%b, sda=%b",
                         done, scl, sda);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, scl=%b, sda=%b",
                         expected_done, expected_scl, expected_sda);
                $display("  Got:      done=%b, scl=%b, sda=%b",
                         done, scl, sda);
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
        $dumpvars(0,clk, data_in, rst, start, stop, done, scl, sda);
    end

endmodule
