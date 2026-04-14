`timescale 1ns/1ps

module linked_list_traversal_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg node_valid;
    reg [7:0] node_value;
    reg rst;
    wire done;
    wire [7:0] output_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linked_list_traversal dut (
        .clk(clk),
        .node_valid(node_valid),
        .node_value(node_value),
        .rst(rst),
        .done(done),
        .output_value(output_value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            node_valid = 0;
            node_value = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Node Traversal (Value: 0xA5)", test_num);
            reset_dut();


            @(posedge clk);
            node_valid <= 1;
            node_value <= 8'hA5;
            @(posedge clk);
            node_valid <= 0;
            node_value <= 0;



            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple Node Traversal (0x11 -> 0x22 -> 0x33)", test_num);
            reset_dut();


            @(posedge clk);
            node_valid <= 1; node_value <= 8'h11; @(posedge clk);
            node_valid <= 1; node_value <= 8'h22; @(posedge clk);
            node_valid <= 1; node_value <= 8'h33; @(posedge clk);
            node_valid <= 0;
            node_value <= 0;


            @(posedge clk);
            #1;

            check_outputs(1'b0, 8'h11);
            @(posedge clk);
            #1;

            check_outputs(1'b0, 8'h22);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'h33);
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] values [0:4];
        begin
            values[0] = 8'h01; values[1] = 8'h02; values[2] = 8'h03;
            values[3] = 8'h04; values[4] = 8'h05;

            test_num = test_num + 1;
            $display("Test Case %0d: Long List Traversal (5 nodes)", test_num);
            reset_dut();


            @(posedge clk);
            node_valid <= 1;
            for (i = 0; i < 5; i = i + 1) begin
                node_value <= values[i];
                @(posedge clk);
            end
            node_valid <= 0;
            node_value <= 0;


            for (i = 0; i < 4; i = i + 1) begin
                @(posedge clk);
                #1;

                check_outputs(1'b0, values[i]);
            end

            @(posedge clk);
            #1;

            check_outputs(1'b1, values[4]);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-load Reset and Recovery", test_num);
            reset_dut();


            @(posedge clk);
            node_valid <= 1; node_value <= 8'hDE; @(posedge clk);
            node_valid <= 1; node_value <= 8'hAD; @(posedge clk);


            rst = 1;
            @(posedge clk);
            rst = 0;
            node_valid <= 0;
            @(posedge clk);


            node_valid <= 1; node_value <= 8'hBE; @(posedge clk);
            node_valid <= 1; node_value <= 8'hEF; @(posedge clk);
            node_valid <= 0;


            @(posedge clk);
            #1;

            check_outputs(1'b0, 8'hBE);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'hEF);
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
        input expected_done;
        input [7:0] expected_output_value;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_output_value === (expected_output_value ^ output_value ^ expected_output_value)) begin
                $display("PASS");
                $display("  Outputs: done=%b, output_value=%h",
                         done, output_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, output_value=%h",
                         expected_done, expected_output_value);
                $display("  Got:      done=%b, output_value=%h",
                         done, output_value);
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
        $dumpvars(0,clk, node_valid, node_value, rst, done, output_value);
    end

endmodule
