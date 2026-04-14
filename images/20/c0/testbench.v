`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr;
    reg clk;
    reg read_req;
    reg rst;
    reg [7:0] write_data;
    reg write_req;
    wire [7:0] read_data;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .addr(addr),
        .clk(clk),
        .read_req(read_req),
        .rst(rst),
        .write_data(write_data),
        .write_req(write_req),
        .read_data(read_data),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            addr = 8'h0;
            read_req = 0;
            write_req = 0;
            write_data = 8'h0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verifying Idle State after Reset", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Basic Write Transaction", test_num);
            reset_dut();


            addr = 8'h10;
            write_data = 8'hAB;
            write_req = 1;


            @(posedge clk);
            #1;
            write_req = 0;


            @(posedge clk);
            #1;


            #1;



            check_outputs(read_data, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Basic Read Transaction", test_num);
            reset_dut();


            addr = 8'h20;
            write_data = 8'hCD;
            write_req = 1;
            @(posedge clk);
            #1;
            write_req = 0;
            @(posedge clk);
            #1;


            addr = 8'h20;
            read_req = 1;
            @(posedge clk);
            #1;
            read_req = 0;


            @(posedge clk);
            #1;


            #1;



            check_outputs(8'hCD, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Back-to-Back Transactions", test_num);
            reset_dut();


            addr = 8'h30;
            write_data = 8'h11;
            write_req = 1;
            @(posedge clk);
            #1;
            write_req = 0;
            @(posedge clk);
            #1;


            addr = 8'h30;
            read_req = 1;
            @(posedge clk);
            #1;
            read_req = 0;
            @(posedge clk);
            #1;


            addr = 8'h40;
            write_data = 8'h22;
            write_req = 1;
            @(posedge clk);
            #1;
            write_req = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h11, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verifying Address Independence", test_num);
            reset_dut();


            addr = 8'hAA;
            write_data = 8'h55;
            write_req = 1;
            @(posedge clk);
            #1;
            write_req = 0;
            @(posedge clk);
            #1;


            addr = 8'hBB;
            write_data = 8'h66;
            write_req = 1;
            @(posedge clk);
            #1;
            write_req = 0;
            @(posedge clk);
            #1;


            addr = 8'hAA;
            read_req = 1;
            @(posedge clk);
            #1;
            read_req = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h55, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
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
        input [7:0] expected_read_data;
        input expected_ready;
        begin
            if (expected_read_data === (expected_read_data ^ read_data ^ expected_read_data) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: read_data=%h, ready=%b",
                         read_data, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_data=%h, ready=%b",
                         expected_read_data, expected_ready);
                $display("  Got:      read_data=%h, ready=%b",
                         read_data, ready);
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
        $dumpvars(0,addr, clk, read_req, rst, write_data, write_req, read_data, ready);
    end

endmodule
