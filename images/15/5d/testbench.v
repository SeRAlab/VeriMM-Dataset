`timescale 1ns/1ps

module pipeline_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] instruction;
    reg reset;
    wire [1:0] instr_type;
    wire [2:0] opcode;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_processor dut (
        .clk(clk),
        .instruction(instruction),
        .reset(reset),
        .instr_type(instr_type),
        .opcode(opcode)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            instruction = 5'b0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset Functionality", test_num);
            reset_dut();

            #1;


            check_outputs(2'b00, 3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Opcode 5 (101), Type 2 (10)", test_num);
            reset_dut();

            instruction = 5'b10110;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10, 3'b101);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Opcode 3 (011), Type 1 (01)", test_num);
            reset_dut();

            instruction = 5'b01101;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01, 3'b011);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: All Zeros (000, 00)", test_num);
            reset_dut();

            instruction = 5'b00000;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00, 3'b000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: All Ones (111, 11)", test_num);
            reset_dut();

            instruction = 5'b11111;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b11, 3'b111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Pipeline Flow Check", test_num);
            reset_dut();

            instruction = 5'b11001;
            @(posedge clk);
            instruction = 5'b00111;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b01, 3'b110);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Second Instruction Latency", test_num);
            reset_dut();

            instruction = 5'b11001;
            @(posedge clk);
            instruction = 5'b00111;
            @(posedge clk);
            instruction = 5'b00000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b11, 3'b001);
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
        testcase006();
        testcase007();
        
        
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
        input [1:0] expected_instr_type;
        input [2:0] expected_opcode;
        begin
            if (expected_instr_type === (expected_instr_type ^ instr_type ^ expected_instr_type) &&
                expected_opcode === (expected_opcode ^ opcode ^ expected_opcode)) begin
                $display("PASS");
                $display("  Outputs: instr_type=%h, opcode=%h",
                         instr_type, opcode);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: instr_type=%h, opcode=%h",
                         expected_instr_type, expected_opcode);
                $display("  Got:      instr_type=%h, opcode=%h",
                         instr_type, opcode);
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
        $dumpvars(0,clk, instruction, reset, instr_type, opcode);
    end

endmodule
