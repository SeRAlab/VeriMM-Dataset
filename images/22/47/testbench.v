`timescale 1ns/1ps

module linked_list_traversal_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] current_data;
    reg [15:0] current_next;
    reg reset;
    wire done;
    wire [7:0] output_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linked_list_traversal dut (
        .clk(clk),
        .current_data(current_data),
        .current_next(current_next),
        .reset(reset),
        .done(done),
        .output_data(output_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            current_data = 0;
            current_next = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: 3-node list traversal", test_num);
            reset_dut();


            current_data = 8'h11;
            current_next = 16'h0001;
            @(posedge clk);
            #1;


            current_data = 8'h22;
            current_next = 16'h0002;
            @(posedge clk);
            #1;


            current_data = 8'h33;
            current_next = 16'h0000;
            @(posedge clk);
            #1;


            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 8'h33);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running testcase%02d: Single-node list", test_num);
            reset_dut();


            current_data = 8'hA5;
            current_next = 16'h0000;
            @(posedge clk);
            #1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: List with zero-value data", test_num);
            reset_dut();


            current_data = 8'hFF;
            current_next = 16'h0005;
            @(posedge clk);
            #1;


            current_data = 8'h00;
            current_next = 16'h0000;
            @(posedge clk);
            #1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: 4-node list with patterns", test_num);
            reset_dut();

            current_data = 8'hDE; current_next = 16'h1001; @(posedge clk); #1;
            current_data = 8'hAD; current_next = 16'h1002; @(posedge clk); #1;
            current_data = 8'hBE; current_next = 16'h1003; @(posedge clk); #1;
            current_data = 8'hEF; current_next = 16'h0000; @(posedge clk); #1;

            @(posedge clk);
            #1;

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
        input [7:0] expected_output_data;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_output_data === (expected_output_data ^ output_data ^ expected_output_data)) begin
                $display("PASS");
                $display("  Outputs: done=%b, output_data=%h",
                         done, output_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, output_data=%h",
                         expected_done, expected_output_data);
                $display("  Got:      done=%b, output_data=%h",
                         done, output_data);
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
        $dumpvars(0,clk, current_data, current_next, reset, done, output_data);
    end

endmodule
