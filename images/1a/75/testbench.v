`timescale 1ns/1ps

module instruction_pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] instruction_in;
    reg rst;
    wire ex_active;
    wire id_active;
    wire if_active;
    wire [31:0] instruction_out;
    wire wb_active;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    instruction_pipeline dut (
        .clk(clk),
        .instruction_in(instruction_in),
        .rst(rst),
        .ex_active(ex_active),
        .id_active(id_active),
        .if_active(if_active),
        .instruction_out(instruction_out),
        .wb_active(wb_active)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            instruction_in = 32'h0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single Instruction Propagation (0x12345678)", test_num);
            reset_dut();


            instruction_in = 32'h12345678;
            @(posedge clk);
            instruction_in = 32'h0;

            @(posedge clk);
            @(posedge clk);
            @(posedge clk);

            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 32'h12345678, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Bits Set Instruction (0xFFFFFFFF)", test_num);
            reset_dut();

            instruction_in = 32'hFFFFFFFF;
            @(posedge clk);
            instruction_in = 32'h0;

            @(posedge clk);
            @(posedge clk);
            @(posedge clk);

            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 32'hFFFFFFFF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reset Mid-Pipeline", test_num);
            reset_dut();

            instruction_in = 32'hABCDE123;
            @(posedge clk);
            @(posedge clk);


            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;


            repeat(2) @(posedge clk);

            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 32'h0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Bits (0x5A5A5A5A)", test_num);
            reset_dut();

            instruction_in = 32'h5A5A5A5A;
            @(posedge clk);
            instruction_in = 32'h0;

            @(posedge clk);
            @(posedge clk);
            @(posedge clk);

            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 32'h5A5A5A5A, 1'b1);
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
        input expected_ex_active;
        input expected_id_active;
        input expected_if_active;
        input [31:0] expected_instruction_out;
        input expected_wb_active;
        begin
            if (expected_ex_active === (expected_ex_active ^ ex_active ^ expected_ex_active) &&
                expected_id_active === (expected_id_active ^ id_active ^ expected_id_active) &&
                expected_if_active === (expected_if_active ^ if_active ^ expected_if_active) &&
                expected_instruction_out === (expected_instruction_out ^ instruction_out ^ expected_instruction_out) &&
                expected_wb_active === (expected_wb_active ^ wb_active ^ expected_wb_active)) begin
                $display("PASS");
                $display("  Outputs: ex_active=%b, id_active=%b, if_active=%b, instruction_out=%h, wb_active=%b",
                         ex_active, id_active, if_active, instruction_out, wb_active);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ex_active=%b, id_active=%b, if_active=%b, instruction_out=%h, wb_active=%b",
                         expected_ex_active, expected_id_active, expected_if_active, expected_instruction_out, expected_wb_active);
                $display("  Got:      ex_active=%b, id_active=%b, if_active=%b, instruction_out=%h, wb_active=%b",
                         ex_active, id_active, if_active, instruction_out, wb_active);
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
        $dumpvars(0,clk, instruction_in, rst, ex_active, id_active, if_active, instruction_out, wb_active);
    end

endmodule
