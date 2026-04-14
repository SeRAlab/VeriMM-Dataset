`timescale 1ns/1ps

module linked_list_traversal_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] index_in;
    reg reset;
    wire [7:0] current_element;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linked_list_traversal dut (
        .clk(clk),
        .index_in(index_in),
        .reset(reset),
        .current_element(current_element)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            index_in = 4'h0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify reset state (Index 0)", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Jump to Index 5", test_num);
            reset_dut();
            index_in = 4'h5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h05);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Jump to Max Index 15", test_num);
            reset_dut();
            index_in = 4'hF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Cyclic Transition (15 -> 0)", test_num);
            reset_dut();

            index_in = 4'hF;
            @(posedge clk);

            #1 index_in = 4'h0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multi-step traversal (0 -> 2 -> 4 -> 8)", test_num);
            reset_dut();

            index_in = 4'h2;
            @(posedge clk);

            #1 index_in = 4'h4;
            @(posedge clk);

            #1 index_in = 4'h8;
            @(posedge clk);

            #1;
            #1;

            check_outputs(8'h08);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("linked_list_traversal Testbench");
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
        input [7:0] expected_current_element;
        begin
            if (expected_current_element === (expected_current_element ^ current_element ^ expected_current_element)) begin
                $display("PASS");
                $display("  Outputs: current_element=%h",
                         current_element);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_element=%h",
                         expected_current_element);
                $display("  Got:      current_element=%h",
                         current_element);
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
        $dumpvars(0,clk, index_in, reset, current_element);
    end

endmodule
