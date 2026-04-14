`timescale 1ns/1ps

module pipelined_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg [31:0] instruction_in;
    reg reset;
    wire [31:0] address_out;
    wire mem_read;
    wire mem_write;
    wire [31:0] result_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipelined_processor dut (
        .clk(clk),
        .data_in(data_in),
        .instruction_in(instruction_in),
        .reset(reset),
        .address_out(address_out),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .result_out(result_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            instruction_in = 0;
            data_in = 0;
            repeat (2) @(posedge clk);
            #1;
            reset = 0;
            $display("DUT Reset Complete");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Arithmetic Operation", test_num);
            reset_dut();


            @(posedge clk);
            instruction_in = 32'h0000_0001;


            repeat(5) @(posedge clk);


            instruction_in = 32'h0;



            #1;




            check_outputs(32'h0, 1'b0, 1'b0, 32'hA5A5A5A5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Memory Read (LOAD)", test_num);
            reset_dut();

            @(posedge clk);
            instruction_in = 32'h1000_000A;


            repeat(3) @(posedge clk);


            data_in = 32'hDEADC0DE;

            @(posedge clk);


            instruction_in = 32'h0;



            #1;




            check_outputs(32'h0000_000A, 1'b1, 1'b0, 32'hDEADC0DE);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Memory Write (STORE)", test_num);
            reset_dut();

            @(posedge clk);
            instruction_in = 32'h2000_00FF;


            repeat(4) @(posedge clk);



            #1;




            check_outputs(32'h0000_00FF, 1'b0, 1'b1, 32'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Pipeline Idle (NOP)", test_num);
            reset_dut();


            instruction_in = 32'h0;
            repeat(6) @(posedge clk);


            #1;



            check_outputs(32'h0, 1'b0, 1'b0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Pipeline Throughput", test_num);
            reset_dut();

            @(posedge clk);
            instruction_in = 32'h0000_0001;
            @(posedge clk);
            instruction_in = 32'h0000_0002;
            @(posedge clk);
            instruction_in = 32'h0000_0003;



            repeat(5) @(posedge clk);



            #1;




            check_outputs(32'h0, 1'b0, 1'b0, 32'h33333333);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipelined_processor Testbench");
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
        input [31:0] expected_address_out;
        input expected_mem_read;
        input expected_mem_write;
        input [31:0] expected_result_out;
        begin
            if (expected_address_out === (expected_address_out ^ address_out ^ expected_address_out) &&
                expected_mem_read === (expected_mem_read ^ mem_read ^ expected_mem_read) &&
                expected_mem_write === (expected_mem_write ^ mem_write ^ expected_mem_write) &&
                expected_result_out === (expected_result_out ^ result_out ^ expected_result_out)) begin
                $display("PASS");
                $display("  Outputs: address_out=%h, mem_read=%b, mem_write=%b, result_out=%h",
                         address_out, mem_read, mem_write, result_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: address_out=%h, mem_read=%b, mem_write=%b, result_out=%h",
                         expected_address_out, expected_mem_read, expected_mem_write, expected_result_out);
                $display("  Got:      address_out=%h, mem_read=%b, mem_write=%b, result_out=%h",
                         address_out, mem_read, mem_write, result_out);
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
        $dumpvars(0,clk, data_in, instruction_in, reset, address_out, mem_read, mem_write, result_out);
    end

endmodule
