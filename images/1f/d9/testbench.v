`timescale 1ns/1ps

module instruction_pipeline_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] address_in;
    reg clk;
    reg [15:0] data_in;
    reg [15:0] instruction_in;
    reg reset;
    wire [15:0] address_out;
    wire [15:0] data_out;
    wire [15:0] instruction_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    instruction_pipeline dut (
        .address_in(address_in),
        .clk(clk),
        .data_in(data_in),
        .instruction_in(instruction_in),
        .reset(reset),
        .address_out(address_out),
        .data_out(data_out),
        .instruction_out(instruction_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            address_in = 16'h0;
            data_in = 16'h0;
            instruction_in = 16'h0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single Instruction Propagation", test_num);
            reset_dut();


            address_in = 16'h1234;
            data_in = 16'h5678;
            instruction_in = 16'hABCD;
            @(posedge clk);


            address_in = 16'h0;
            data_in = 16'h0;
            instruction_in = 16'h0;
            @(posedge clk);


            @(posedge clk);


            #2;
            #1;

            check_outputs(16'h1234, 16'h5678, 16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Pipeline Throughput Check", test_num);
            reset_dut();


            address_in = 16'h1111;
            data_in = 16'h2222;
            instruction_in = 16'h3333;
            @(posedge clk);


            address_in = 16'h4444;
            data_in = 16'h5555;
            instruction_in = 16'h6666;
            @(posedge clk);


            address_in = 16'h7777;
            data_in = 16'h8888;
            instruction_in = 16'h9999;
            @(posedge clk);

            #2;
            $display("Checking first instruction in stream...");
            #1;

            check_outputs(16'h1111, 16'h2222, 16'h3333);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reset Functionality during Operation", test_num);
            reset_dut();


            address_in = 16'hAAAA;
            data_in = 16'hBBBB;
            instruction_in = 16'hCCCC;
            @(posedge clk);
            @(posedge clk);


            reset = 1;
            @(posedge clk);
            #1 reset = 0;


            #2;
            #1;

            check_outputs(16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Max Bit Value Propagation", test_num);
            reset_dut();

            address_in = 16'hFFFF;
            data_in = 16'hFFFF;
            instruction_in = 16'hFFFF;

            repeat(3) @(posedge clk);

            #2;
            #1;

            check_outputs(16'hFFFF, 16'hFFFF, 16'hFFFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("instruction_pipeline Testbench");
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
        input [15:0] expected_address_out;
        input [15:0] expected_data_out;
        input [15:0] expected_instruction_out;
        begin
            if (expected_address_out === (expected_address_out ^ address_out ^ expected_address_out) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_instruction_out === (expected_instruction_out ^ instruction_out ^ expected_instruction_out)) begin
                $display("PASS");
                $display("  Outputs: address_out=%h, data_out=%h, instruction_out=%h",
                         address_out, data_out, instruction_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: address_out=%h, data_out=%h, instruction_out=%h",
                         expected_address_out, expected_data_out, expected_instruction_out);
                $display("  Got:      address_out=%h, data_out=%h, instruction_out=%h",
                         address_out, data_out, instruction_out);
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
        $dumpvars(0,address_in, clk, data_in, instruction_in, reset, address_out, data_out, instruction_out);
    end

endmodule
