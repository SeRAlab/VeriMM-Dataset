`timescale 1ns/1ps

module pipeline_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] instruction_type;
    reg reset;
    wire [6:0] control_signals;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_controller dut (
        .clk(clk),
        .instruction_type(instruction_type),
        .reset(reset),
        .control_signals(control_signals)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            instruction_type = 3'b000;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(7'b0000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            instruction_type = 3'b001;
            @(posedge clk);
            #1;

            #1;


            check_outputs(7'b1000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            instruction_type = 3'b010;
            @(posedge clk);
            instruction_type = 3'b000;
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(7'b0001000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            instruction_type = 3'b011;
            @(posedge clk);
            instruction_type = 3'b000;
            repeat(6) @(posedge clk);
            #1;

            #1;


            check_outputs(7'b0000001);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            repeat(7) begin
                instruction_type = 3'b100;
                @(posedge clk);
            end
            #1;

            #1;


            check_outputs(7'b1111111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            repeat(7) begin
                instruction_type = 3'b101;
                @(posedge clk);
            end

            instruction_type = 3'b000;
            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(7'b0000111);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            instruction_type = 3'b000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(7'b0000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipeline_controller Testbench");
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
        input [6:0] expected_control_signals;
        begin
            if (expected_control_signals === (expected_control_signals ^ control_signals ^ expected_control_signals)) begin
                $display("PASS");
                $display("  Outputs: control_signals=%h",
                         control_signals);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: control_signals=%h",
                         expected_control_signals);
                $display("  Got:      control_signals=%h",
                         control_signals);
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
        $dumpvars(0,clk, instruction_type, reset, control_signals);
    end

endmodule
