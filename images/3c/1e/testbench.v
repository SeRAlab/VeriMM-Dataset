`timescale 1ns/1ps

module i2c_master_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg [6:0] slave_addr;
    reg start;
    wire [7:0] data_out;
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
        .reset(reset),
        .slave_addr(slave_addr),
        .start(start),
        .data_out(data_out),
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
            reset = 1;
            start = 0;
            data_in = 8'h00;
            slave_addr = 7'h00;
            #20;
            reset = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Write Operation (Addr: 0x50, Data: 0xA5)", test_num);
            reset_dut();

            @(posedge clk);
            slave_addr = 7'h50;
            data_in = 8'hA5;
            start = 1;
            @(posedge clk);
            start = 0;



            wait(done == 1);
            #100;


            #1;



            check_outputs(8'h00, 1, 1, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Read Operation (Addr: 0x3C)", test_num);
            reset_dut();

            @(posedge clk);
            slave_addr = 7'h3C;


            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1);
            #100;



            #1;




            check_outputs(data_out, 1, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Write Operation (Addr: 0x27, Data: 0x5A)", test_num);
            reset_dut();

            @(posedge clk);
            slave_addr = 7'h27;
            data_in = 8'h5A;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1);
            #100;
            #1;

            check_outputs(8'h00, 1, 1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Boundary Check - All Zeros", test_num);
            reset_dut();

            @(posedge clk);
            slave_addr = 7'h00;
            data_in = 8'h00;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1);
            #100;
            #1;

            check_outputs(8'h00, 1, 1, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Boundary Check - All Ones", test_num);
            reset_dut();

            @(posedge clk);
            slave_addr = 7'h7F;
            data_in = 8'hFF;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1);
            #100;
            #1;

            check_outputs(8'h00, 1, 1, 1);
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
        input [7:0] expected_data_out;
        input expected_done;
        input expected_scl;
        input expected_sda;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_done === (expected_done ^ done ^ expected_done) &&
                expected_scl === (expected_scl ^ scl ^ expected_scl) &&
                expected_sda === (expected_sda ^ sda ^ expected_sda)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, done=%b, scl=%b, sda=%b",
                         data_out, done, scl, sda);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, done=%b, scl=%b, sda=%b",
                         expected_data_out, expected_done, expected_scl, expected_sda);
                $display("  Got:      data_out=%h, done=%b, scl=%b, sda=%b",
                         data_out, done, scl, sda);
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
        $dumpvars(0,clk, data_in, reset, slave_addr, start, data_out, done, scl, sda);
    end

endmodule
