`timescale 1ns/1ps

module linked_list_traversal_tb;

    // Testbench signals (sequential circuit)
    reg add_node;
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg traverse;
    wire [7:0] current_data;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linked_list_traversal dut (
        .add_node(add_node),
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .traverse(traverse),
        .current_data(current_data),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            add_node = 0;
            traverse = 0;
            data_in = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Add one node and traverse...");
            reset_dut();


            data_in = 8'hA1;
            add_node = 1;
            @(posedge clk);
            #1;
            add_node = 0;
            @(posedge clk);


            traverse = 1;
            @(posedge clk);
            #1;
            traverse = 0;
            @(posedge clk);


            #1;



            check_outputs(8'hA1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Add two nodes and traverse to the second...");
            reset_dut();


            data_in = 8'h11;
            add_node = 1;
            @(posedge clk);
            #1;


            data_in = 8'h22;
            add_node = 1;
            @(posedge clk);
            #1;
            add_node = 0;
            @(posedge clk);


            traverse = 1;
            @(posedge clk);
            #1;

            @(posedge clk);
            #1;
            traverse = 0;
            @(posedge clk);


            #1;



            check_outputs(8'h22, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Traverse an empty list...");
            reset_dut();


            traverse = 1;
            @(posedge clk);
            #1;
            traverse = 0;
            @(posedge clk);


            #1;



            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        reg [7:0] values [0:4];
        begin
            $display("\nRunning testcase004: Fill list (5 nodes) and traverse to tail...");
            values[0] = 8'h10; values[1] = 8'h20; values[2] = 8'h30; values[3] = 8'h40; values[4] = 8'h50;
            reset_dut();


            for (i = 0; i < 5; i = i + 1) begin
                data_in = values[i];
                add_node = 1;
                @(posedge clk);
                #1;
            end
            add_node = 0;
            @(posedge clk);


            traverse = 1;
            for (i = 0; i < 5; i = i + 1) begin
                @(posedge clk);
                #1;
            end
            traverse = 0;
            @(posedge clk);


            #1;



            check_outputs(8'h50, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Add nodes and verify reset clears state...");
            reset_dut();


            data_in = 8'hFF;
            add_node = 1;
            @(posedge clk);
            #1;
            add_node = 0;


            traverse = 1;
            @(posedge clk);
            #1;
            traverse = 0;


            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);


            #1;



            check_outputs(8'h00, 1'b0);
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
        input [7:0] expected_current_data;
        input expected_valid;
        begin
            if (expected_current_data === (expected_current_data ^ current_data ^ expected_current_data) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: current_data=%h, valid=%b",
                         current_data, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_data=%h, valid=%b",
                         expected_current_data, expected_valid);
                $display("  Got:      current_data=%h, valid=%b",
                         current_data, valid);
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
        $dumpvars(0,add_node, clk, data_in, reset, traverse, current_data, valid);
    end

endmodule
