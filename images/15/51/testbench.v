`timescale 1ns/1ps

module SD_Card_Controller_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] block_addr;
    reg clk;
    reg [7:0] data_in;
    reg read_req;
    reg reset;
    reg write_req;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SD_Card_Controller dut (
        .block_addr(block_addr),
        .clk(clk),
        .data_in(data_in),
        .read_req(read_req),
        .reset(reset),
        .write_req(write_req),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            block_addr = 0;
            data_in = 0;
            read_req = 0;
            write_req = 0;
            repeat(2) @(negedge clk);
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Write and Read (Block 0)", test_num);
            reset_dut();


            block_addr = 2'b00;
            data_in = 8'hAA;
            write_req = 1;
            @(negedge clk);
            write_req = 0;
            @(negedge clk);


            read_req = 1;
            block_addr = 2'b00;
            @(negedge clk);
            read_req = 0;
            @(negedge clk);

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multi-block Write and Read (Block 3)", test_num);
            reset_dut();


            block_addr = 2'b00; data_in = 8'h11; write_req = 1; @(negedge clk);
            block_addr = 2'b01; data_in = 8'h22; write_req = 1; @(negedge clk);
            block_addr = 2'b10; data_in = 8'h33; write_req = 1; @(negedge clk);
            block_addr = 2'b11; data_in = 8'h44; write_req = 1; @(negedge clk);
            write_req = 0;
            @(negedge clk);


            read_req = 1;
            block_addr = 2'b11;
            @(negedge clk);
            read_req = 0;
            @(negedge clk);

            #1;


            check_outputs(8'h44);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Overwrite Block", test_num);
            reset_dut();


            block_addr = 2'b10;
            data_in = 8'h55;
            write_req = 1;
            @(negedge clk);


            data_in = 8'hFF;
            write_req = 1;
            @(negedge clk);
            write_req = 0;
            @(negedge clk);


            read_req = 1;
            block_addr = 2'b10;
            @(negedge clk);
            read_req = 0;
            @(negedge clk);

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Read Post-Reset State", test_num);
            reset_dut();


            read_req = 1;
            block_addr = 2'b01;
            @(negedge clk);
            read_req = 0;
            @(negedge clk);


            #1;



            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Interleaved Read/Write", test_num);
            reset_dut();


            block_addr = 2'b00; data_in = 8'h12; write_req = 1; @(negedge clk);
            write_req = 0;


            read_req = 1; block_addr = 2'b00;
            data_in = 8'h34; write_req = 1; block_addr = 2'b01;
            @(negedge clk);


            read_req = 0;
            write_req = 0;
            @(negedge clk);

            #1;


            check_outputs(8'h12);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SD_Card_Controller Testbench");
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
        $dumpvars(0,block_addr, clk, data_in, read_req, reset, write_req, data_out);
    end

endmodule
