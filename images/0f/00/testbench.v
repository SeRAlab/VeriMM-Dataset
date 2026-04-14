`timescale 1ns/1ps

module instruction_pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] opcode;
    reg [3:0] operand;
    reg rst;
    wire [1:0] current_opcode;
    wire [3:0] current_operand;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    instruction_pipeline dut (
        .clk(clk),
        .opcode(opcode),
        .operand(operand),
        .rst(rst),
        .current_opcode(current_opcode),
        .current_operand(current_operand)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            opcode = 0;
            operand = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Single basic instruction (2'b10, 4'h5)");
            test_num = test_num + 1;
            reset_dut();


            opcode = 2'b10;
            operand = 4'h5;
            @(posedge clk);


            opcode = 0;
            operand = 0;
            repeat(4) @(posedge clk);

            #2;
            #1;

            check_outputs(2'b10, 4'h5);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Maximum values (2'b11, 4'hF)");
            test_num = test_num + 1;
            reset_dut();

            opcode = 2'b11;
            operand = 4'hF;
            @(posedge clk);

            opcode = 0;
            operand = 0;
            repeat(4) @(posedge clk);

            #2;
            #1;

            check_outputs(2'b11, 4'hF);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Minimum values (2'b00, 4'h0)");
            test_num = test_num + 1;
            reset_dut();


            opcode = 2'b11;
            operand = 4'hA;
            @(posedge clk);


            opcode = 2'b00;
            operand = 4'h0;
            @(posedge clk);

            opcode = 0;
            operand = 0;
            repeat(4) @(posedge clk);

            #2;
            #1;

            check_outputs(2'b00, 4'h0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Pipeline flow (Sequential instructions)");
            test_num = test_num + 1;
            reset_dut();


            opcode = 2'b01; operand = 4'h1; @(posedge clk);
            opcode = 2'b10; operand = 4'h2; @(posedge clk);
            opcode = 2'b11; operand = 4'h3; @(posedge clk);
            opcode = 2'b00; operand = 4'h4; @(posedge clk);
            opcode = 2'b10; operand = 4'hA; @(posedge clk);


            opcode = 2'b00;
            operand = 4'h0;
            repeat(4) @(posedge clk);

            #2;

            #1;


            check_outputs(2'b10, 4'hA);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Reset mid-stream");
            test_num = test_num + 1;
            reset_dut();


            opcode = 2'b11;
            operand = 4'hE;
            repeat(3) @(posedge clk);


            rst = 1;
            @(posedge clk);
            rst = 0;


            repeat(5) @(posedge clk);

            #2;

            #1;


            check_outputs(2'b00, 4'h0);
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
        input [1:0] expected_current_opcode;
        input [3:0] expected_current_operand;
        begin
            if (expected_current_opcode === (expected_current_opcode ^ current_opcode ^ expected_current_opcode) &&
                expected_current_operand === (expected_current_operand ^ current_operand ^ expected_current_operand)) begin
                $display("PASS");
                $display("  Outputs: current_opcode=%h, current_operand=%h",
                         current_opcode, current_operand);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_opcode=%h, current_operand=%h",
                         expected_current_opcode, expected_current_operand);
                $display("  Got:      current_opcode=%h, current_operand=%h",
                         current_opcode, current_operand);
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
        $dumpvars(0,clk, opcode, operand, rst, current_opcode, current_operand);
    end

endmodule
