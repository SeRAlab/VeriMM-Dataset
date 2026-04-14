`timescale 1ns/1ps

module pipeline_processor_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg clk;
    reg [2:0] opcode;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_processor dut (
        .A(A),
        .B(B),
        .clk(clk),
        .opcode(opcode),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 8'h0;
            B = 8'h0;
            opcode = 3'h0;

            repeat (8) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            A = 8'd25;
            B = 8'd15;
            opcode = OP_ADD;
            @(posedge clk);

            repeat (7) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd40);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            A = 8'd100;
            B = 8'd40;
            opcode = OP_SUB;
            @(posedge clk);
            repeat (7) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd60);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            A = 8'hAA;
            B = 8'hF0;
            opcode = OP_AND;
            @(posedge clk);
            repeat (7) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            A = 8'h55;
            B = 8'h0F;
            opcode = OP_OR;
            @(posedge clk);
            repeat (7) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h5F);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            A = 8'hFF;
            B = 8'hAA;
            opcode = OP_XOR;
            @(posedge clk);
            repeat (7) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            A = 8'd250;
            B = 8'd10;
            opcode = OP_ADD;
            @(posedge clk);
            repeat (7) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd4);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            A = 8'd10;
            B = 8'd20;
            opcode = OP_SUB;
            @(posedge clk);
            repeat (7) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hF6);
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
        input [7:0] expected_result;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
        $dumpvars(0,A, B, clk, opcode, result);
    end

endmodule
