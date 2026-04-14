`timescale 1ns/1ps

module instruction_pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] instruction_in;
    reg reset;
    wire [15:0] decode_out;
    wire [15:0] execute_out;
    wire [15:0] fetch_out;
    wire [15:0] memory_out;
    wire [15:0] write_back_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    instruction_pipeline dut (
        .clk(clk),
        .instruction_in(instruction_in),
        .reset(reset),
        .decode_out(decode_out),
        .execute_out(execute_out),
        .fetch_out(fetch_out),
        .memory_out(memory_out),
        .write_back_out(write_back_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            instruction_in = 16'h0000;
            @(negedge clk);
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Continuous Instruction Stream", test_num);
            reset_dut();


            instruction_in = 16'h1111; @(negedge clk);

            instruction_in = 16'h2222; @(negedge clk);

            instruction_in = 16'h3333; @(negedge clk);

            instruction_in = 16'h4444; @(negedge clk);

            instruction_in = 16'h5555; @(negedge clk);








            #1;









            check_outputs(16'h4444, 16'h3333, 16'h5555, 16'h2222, 16'h1111);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset during operation", test_num);
            reset_dut();


            instruction_in = 16'hAAAA; @(negedge clk);
            instruction_in = 16'hBBBB; @(negedge clk);


            reset = 1;
            @(negedge clk);
            reset = 0;


            #1;



            check_outputs(16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Instruction Propagation", test_num);
            reset_dut();


            instruction_in = 16'hFACE; @(negedge clk);

            instruction_in = 16'h0000; @(negedge clk);
            instruction_in = 16'h0000; @(negedge clk);
            instruction_in = 16'h0000; @(negedge clk);
            instruction_in = 16'h0000; @(negedge clk);


            #1;



            check_outputs(16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'hFACE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Intermittent Instruction Stream", test_num);
            reset_dut();

            instruction_in = 16'hA001; @(negedge clk);
            instruction_in = 16'h0000; @(negedge clk);
            instruction_in = 16'hB002; @(negedge clk);
            instruction_in = 16'h0000; @(negedge clk);
            instruction_in = 16'hC003; @(negedge clk);







            #1;








            check_outputs(16'h0000, 16'hB002, 16'hC003, 16'h0000, 16'hA001);
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
        input [15:0] expected_decode_out;
        input [15:0] expected_execute_out;
        input [15:0] expected_fetch_out;
        input [15:0] expected_memory_out;
        input [15:0] expected_write_back_out;
        begin
            if (expected_decode_out === (expected_decode_out ^ decode_out ^ expected_decode_out) &&
                expected_execute_out === (expected_execute_out ^ execute_out ^ expected_execute_out) &&
                expected_fetch_out === (expected_fetch_out ^ fetch_out ^ expected_fetch_out) &&
                expected_memory_out === (expected_memory_out ^ memory_out ^ expected_memory_out) &&
                expected_write_back_out === (expected_write_back_out ^ write_back_out ^ expected_write_back_out)) begin
                $display("PASS");
                $display("  Outputs: decode_out=%h, execute_out=%h, fetch_out=%h, memory_out=%h, write_back_out=%h",
                         decode_out, execute_out, fetch_out, memory_out, write_back_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decode_out=%h, execute_out=%h, fetch_out=%h, memory_out=%h, write_back_out=%h",
                         expected_decode_out, expected_execute_out, expected_fetch_out, expected_memory_out, expected_write_back_out);
                $display("  Got:      decode_out=%h, execute_out=%h, fetch_out=%h, memory_out=%h, write_back_out=%h",
                         decode_out, execute_out, fetch_out, memory_out, write_back_out);
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
        $dumpvars(0,clk, instruction_in, reset, decode_out, execute_out, fetch_out, memory_out, write_back_out);
    end

endmodule
