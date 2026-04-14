`timescale 1ns/1ps

module pipeline_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] control_in;
    reg [31:0] instruction_in;
    wire [4:0] control_out;
    wire [31:0] instruction_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_register dut (
        .clk(clk),
        .control_in(control_in),
        .instruction_in(instruction_in),
        .control_out(control_out),
        .instruction_out(instruction_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            control_in = 0;
            instruction_in = 0;

            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Basic Data Load", test_num);
            reset_dut();


            control_in = 5'b10101;
            instruction_in = 32'hDEADBEEF;


            @(posedge clk);
            #2;

            #1;


            check_outputs(5'b10101, 32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones Pattern", test_num);
            reset_dut();

            control_in = 5'b11111;
            instruction_in = 32'hFFFFFFFF;

            @(posedge clk);
            #2;

            #1;


            check_outputs(5'b11111, 32'hFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros Pattern", test_num);
            reset_dut();


            control_in = 5'b11111;
            instruction_in = 32'hFFFFFFFF;
            @(posedge clk);
            #1;


            control_in = 5'b00000;
            instruction_in = 32'h00000000;
            @(posedge clk);
            #2;

            #1;


            check_outputs(5'b00000, 32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Bits", test_num);
            reset_dut();

            control_in = 5'b01010;
            instruction_in = 32'h55AA55AA;

            @(posedge clk);
            #2;

            #1;


            check_outputs(5'b01010, 32'h55AA55AA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum Values and Boundaries", test_num);
            reset_dut();

            control_in = 5'h1F;
            instruction_in = 32'h80000001;

            @(posedge clk);
            #2;

            #1;


            check_outputs(5'h1F, 32'h80000001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipeline_register Testbench");
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
        input [4:0] expected_control_out;
        input [31:0] expected_instruction_out;
        begin
            if (expected_control_out === (expected_control_out ^ control_out ^ expected_control_out) &&
                expected_instruction_out === (expected_instruction_out ^ instruction_out ^ expected_instruction_out)) begin
                $display("PASS");
                $display("  Outputs: control_out=%h, instruction_out=%h",
                         control_out, instruction_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: control_out=%h, instruction_out=%h",
                         expected_control_out, expected_instruction_out);
                $display("  Got:      control_out=%h, instruction_out=%h",
                         control_out, instruction_out);
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
        $dumpvars(0,clk, control_in, instruction_in, control_out, instruction_out);
    end

endmodule
