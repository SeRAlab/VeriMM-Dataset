`timescale 1ns/1ps

module RRT_Node_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] command;
    reg [15:0] new_node;
    reg reset;
    wire [15:0] current_node;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RRT_Node dut (
        .clk(clk),
        .command(command),
        .new_node(new_node),
        .reset(reset),
        .current_node(current_node)
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
            command = 4'h0;
            new_node = 16'h0000;
            @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Checking Reset State");
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Add New Node");
            reset_dut();
            @(posedge clk);
            command = 4'h1;
            new_node = 16'hA5A5;
            @(posedge clk);
            command = 4'h0;
            @(posedge clk);
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Move to Specified Node");
            reset_dut();
            @(posedge clk);
            command = 4'h2;
            new_node = 16'h5A5A;
            @(posedge clk);
            command = 4'h0;
            @(posedge clk);
            #1;

            check_outputs(16'h5A5A);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Sequential Add and Move");
            reset_dut();


            @(posedge clk);
            command = 4'h1;
            new_node = 16'h1111;


            @(posedge clk);
            command = 4'h2;
            new_node = 16'h2222;

            @(posedge clk);
            command = 4'h0;
            @(posedge clk);
            #1;

            check_outputs(16'h2222);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Data Persistence on No-Op");
            reset_dut();


            @(posedge clk);
            command = 4'h1;
            new_node = 16'hBEEF;
            @(posedge clk);


            command = 4'h0;
            new_node = 16'hDEAD;


            repeat(3) @(posedge clk);


            #1;



            check_outputs(16'hBEEF);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Reset during operation");
            reset_dut();

            @(posedge clk);
            command = 4'h1;
            new_node = 16'hFFFF;
            @(posedge clk);


            reset = 1;
            @(posedge clk);
            reset = 0;
            @(posedge clk);

            #1;


            check_outputs(16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("RRT_Node Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [15:0] expected_current_node;
        begin
            if (expected_current_node === (expected_current_node ^ current_node ^ expected_current_node)) begin
                $display("PASS");
                $display("  Outputs: current_node=%h",
                         current_node);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_node=%h",
                         expected_current_node);
                $display("  Got:      current_node=%h",
                         current_node);
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
        $dumpvars(0,clk, command, new_node, reset, current_node);
    end

endmodule
