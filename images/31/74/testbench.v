`timescale 1ns/1ps

module pipeline_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] instruction_in;
    reg rst;
    wire [31:0] write_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_processor dut (
        .clk(clk),
        .instruction_in(instruction_in),
        .rst(rst),
        .write_data(write_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            instruction_in = NOP;
            @(posedge clk);
            @(posedge clk);
            #1 rst = 0;
            $display("System Reset Sequence Complete.");
        end
        endtask
    task send_instruction;

        input [31:0] inst;
        begin
            instruction_in = inst;
            @(posedge clk);
            instruction_in = NOP;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Basic Arithmetic (ADD)", test_num);
            reset_dut();



            send_instruction(32'h00000820);


            repeat(10) @(posedge clk);



            #1;




            check_outputs(32'h0000000A);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Data Forwarding (RAW Hazard)", test_num);
            reset_dut();

            instruction_in = 32'h00430820;
            @(posedge clk);
            instruction_in = 32'h00222022;
            @(posedge clk);
            instruction_in = NOP;


            repeat(12) @(posedge clk);


            #1;



            check_outputs(32'h00000005);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Hazard Detection (Load-Use Stall)", test_num);
            reset_dut();

            instruction_in = 32'h8C410000;
            @(posedge clk);
            instruction_in = 32'h00241820;
            @(posedge clk);
            instruction_in = NOP;


            repeat(13) @(posedge clk);


            #1;



            check_outputs(32'h000000FF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Pipeline Throughput", test_num);
            reset_dut();

            instruction_in = 32'h20010001;
            @(posedge clk);
            instruction_in = 32'h20020002;
            @(posedge clk);
            instruction_in = 32'h20030003;
            @(posedge clk);
            instruction_in = NOP;

            repeat(15) @(posedge clk);


            #1;



            check_outputs(32'h00000003);
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
        input [31:0] expected_write_data;
        begin
            if (expected_write_data === (expected_write_data ^ write_data ^ expected_write_data)) begin
                $display("PASS");
                $display("  Outputs: write_data=%h",
                         write_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: write_data=%h",
                         expected_write_data);
                $display("  Got:      write_data=%h",
                         write_data);
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
        $dumpvars(0,clk, instruction_in, rst, write_data);
    end

endmodule
