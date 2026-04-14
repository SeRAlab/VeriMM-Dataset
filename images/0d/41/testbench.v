`timescale 1ns/1ps

module pipeline_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] opcode_in;
    reg [2:0] reg_in;
    reg rst;
    wire [1:0] opcode_out;
    wire [2:0] reg_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_processor dut (
        .clk(clk),
        .opcode_in(opcode_in),
        .reg_in(reg_in),
        .rst(rst),
        .opcode_out(opcode_out),
        .reg_out(reg_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            opcode_in = 2'b00;
            reg_in = 3'b000;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic propagation - Minimum values", test_num);
            reset_dut();


            opcode_in = 2'b00;
            reg_in = 3'b000;
            @(posedge clk);


            repeat (4) @(posedge clk);


            #1;



            check_outputs(2'b00, 3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic propagation - Maximum values", test_num);
            reset_dut();

            opcode_in = 2'b11;
            reg_in = 3'b111;
            @(posedge clk);


            opcode_in = 2'b00;
            reg_in = 3'b000;

            repeat (4) @(posedge clk);
            #1;

            check_outputs(2'b11, 3'b111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Propagation - Alternating bits", test_num);
            reset_dut();

            opcode_in = 2'b10;
            reg_in = 3'b101;
            @(posedge clk);

            opcode_in = 2'b00;
            reg_in = 3'b000;

            repeat (4) @(posedge clk);
            #1;

            check_outputs(2'b10, 3'b101);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Propagation - Complementary bits", test_num);
            reset_dut();

            opcode_in = 2'b01;
            reg_in = 3'b010;
            @(posedge clk);

            opcode_in = 2'b00;
            reg_in = 3'b000;

            repeat (4) @(posedge clk);
            #1;

            check_outputs(2'b01, 3'b010);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset during propagation", test_num);
            reset_dut();

            opcode_in = 2'b11;
            reg_in = 3'b111;
            @(posedge clk);
            @(posedge clk);


            rst = 1;
            @(posedge clk);
            rst = 0;

            repeat (3) @(posedge clk);


            #1;



            check_outputs(2'b00, 3'b000);
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
        input [1:0] expected_opcode_out;
        input [2:0] expected_reg_out;
        begin
            if (expected_opcode_out === (expected_opcode_out ^ opcode_out ^ expected_opcode_out) &&
                expected_reg_out === (expected_reg_out ^ reg_out ^ expected_reg_out)) begin
                $display("PASS");
                $display("  Outputs: opcode_out=%h, reg_out=%h",
                         opcode_out, reg_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: opcode_out=%h, reg_out=%h",
                         expected_opcode_out, expected_reg_out);
                $display("  Got:      opcode_out=%h, reg_out=%h",
                         opcode_out, reg_out);
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
        $dumpvars(0,clk, opcode_in, reg_in, rst, opcode_out, reg_out);
    end

endmodule
