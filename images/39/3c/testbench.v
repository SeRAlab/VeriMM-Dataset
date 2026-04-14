`timescale 1ns/1ps

module linked_list_traversal_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] add_element;
    reg clk;
    reg reset;
    reg traverse;
    wire [7:0] output_element;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linked_list_traversal dut (
        .add_element(add_element),
        .clk(clk),
        .reset(reset),
        .traverse(traverse),
        .output_element(output_element)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            add_element = 0;
            traverse = 0;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Single Element Addition and Traversal");
            test_num = 1;
            reset_dut();


            add_element = 8'hAA;
            @(posedge clk);
            add_element = 0;
            @(posedge clk);


            traverse = 1;
            @(posedge clk);
            traverse = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Multiple Element Traversal (to 3rd)");
            test_num = 2;
            reset_dut();


            add_element = 8'h11; @(posedge clk);
            add_element = 8'h22; @(posedge clk);
            add_element = 8'h33; @(posedge clk);
            add_element = 0;
            @(posedge clk);


            traverse = 1; @(posedge clk);
            traverse = 1; @(posedge clk);
            traverse = 1; @(posedge clk);
            traverse = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(8'h33);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Max Capacity Traversal (5 elements)");
            test_num = 3;
            reset_dut();


            add_element = 8'h01; @(posedge clk);
            add_element = 8'h02; @(posedge clk);
            add_element = 8'h03; @(posedge clk);
            add_element = 8'h04; @(posedge clk);
            add_element = 8'h05; @(posedge clk);
            add_element = 0;
            @(posedge clk);


            repeat(5) begin
                traverse = 1;
                @(posedge clk);
                traverse = 0;
                @(posedge clk);
            end

            #1;


            check_outputs(8'h05);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Reset Mid-Operation");
            test_num = 4;
            reset_dut();


            add_element = 8'hA1; @(posedge clk);
            add_element = 8'hB2; @(posedge clk);
            add_element = 0;


            reset_dut();


            traverse = 1;
            @(posedge clk);
            traverse = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Middle Element Access");
            test_num = 5;
            reset_dut();


            add_element = 8'hDE; @(posedge clk);
            add_element = 8'hAD; @(posedge clk);
            add_element = 8'hBE; @(posedge clk);
            add_element = 8'hEF; @(posedge clk);
            add_element = 0;
            @(posedge clk);


            traverse = 1; @(posedge clk);
            traverse = 1; @(posedge clk);
            traverse = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(8'hAD);
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
        input [7:0] expected_output_element;
        begin
            if (expected_output_element === (expected_output_element ^ output_element ^ expected_output_element)) begin
                $display("PASS");
                $display("  Outputs: output_element=%h",
                         output_element);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_element=%h",
                         expected_output_element);
                $display("  Got:      output_element=%h",
                         output_element);
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
        $dumpvars(0,add_element, clk, reset, traverse, output_element);
    end

endmodule
