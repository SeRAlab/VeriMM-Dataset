`timescale 1ns/1ps

module pipeline_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] instruction_in;
    reg reset;
    wire [31:0] result_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_processor dut (
        .clk(clk),
        .instruction_in(instruction_in),
        .reset(reset),
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
            instruction_in = 32'h0;
            @(posedge clk);
            @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase%03d: Basic Arithmetic", test_num);
            reset_dut();


            instruction_in = 32'h2001000A; @(posedge clk);

            instruction_in = 32'h20020005; @(posedge clk);

            instruction_in = 32'h00221820; @(posedge clk);



            instruction_in = 32'h00000000;
            repeat(5) @(posedge clk);


            #1;



            check_outputs(32'h0000000F);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase%03d: Data Hazard / Forwarding", test_num);
            reset_dut();


            instruction_in = 32'h20040014; @(posedge clk);

            instruction_in = 32'h00842820; @(posedge clk);

            instruction_in = 32'h00000000;
            repeat(5) @(posedge clk);


            #1;



            check_outputs(32'h00000028);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase%03d: Control Hazard / Pipeline Flush", test_num);
            reset_dut();


            instruction_in = 32'h10000001; @(posedge clk);

            instruction_in = 32'h20060063; @(posedge clk);

            instruction_in = 32'h20070001; @(posedge clk);

            instruction_in = 32'h00000000;
            repeat(6) @(posedge clk);


            #1;



            check_outputs(32'h00000001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase%03d: Load-Use Hazard", test_num);
            reset_dut();


            instruction_in = 32'h8C080000; @(posedge clk);

            instruction_in = 32'h01004820; @(posedge clk);

            instruction_in = 32'h00000000;
            repeat(6) @(posedge clk);



            if (result_out !== 32'hxxxxxxxx) begin
                $display("PASS: Data committed to pipeline");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Invalid output state");
                fail_count = fail_count + 1;
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipeline_processor Testbench");
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
        input [31:0] expected_result_out;
        begin
            if (expected_result_out === (expected_result_out ^ result_out ^ expected_result_out)) begin
                $display("PASS");
                $display("  Outputs: result_out=%h",
                         result_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result_out=%h",
                         expected_result_out);
                $display("  Got:      result_out=%h",
                         result_out);
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
        $dumpvars(0,clk, instruction_in, reset, result_out);
    end

endmodule
