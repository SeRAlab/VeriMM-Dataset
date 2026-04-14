`timescale 1ns/1ps

module dfs_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg move_left;
    reg move_right;
    reg [3:0] node_value;
    reg reset;
    wire [15:0] path;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dfs dut (
        .clk(clk),
        .move_left(move_left),
        .move_right(move_right),
        .node_value(node_value),
        .reset(reset),
        .path(path)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            move_left = 0;
            move_right = 0;
            node_value = 4'h0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Single Left move...");
            reset_dut();
            node_value = 4'h1;
            move_left = 1;
            @(posedge clk);
            #1 move_left = 0;
            repeat(1) @(posedge clk);
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Single Right move...");
            reset_dut();
            node_value = 4'h2;
            move_right = 1;
            @(posedge clk);
            #1 move_right = 0;
            repeat(1) @(posedge clk);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: L-R-L sequence...");
            reset_dut();


            node_value = 4'hA; move_left = 1; @(posedge clk); #1 move_left = 0;

            node_value = 4'hB; move_right = 1; @(posedge clk); #1 move_right = 0;

            node_value = 4'hC; move_left = 1; @(posedge clk); #1 move_left = 0;

            repeat(1) @(posedge clk);
            #1;

            check_outputs(16'h0005);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Four Left moves...");
            reset_dut();
            repeat(4) begin
                node_value = node_value + 1;
                move_left = 1;
                @(posedge clk);
                #1 move_left = 0;
            end
            #1;

            check_outputs(16'h000F);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: R-R-L-R sequence...");
            reset_dut();

            move_right = 1; @(posedge clk); #1 move_right = 0;

            move_right = 1; @(posedge clk); #1 move_right = 0;

            move_left = 1;  @(posedge clk); #1 move_left = 0;

            move_right = 1; @(posedge clk); #1 move_right = 0;

            #1;


            check_outputs(16'h0002);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Complex path L-L-R-R-L-R-L...");
            reset_dut();

            move_left = 1; @(posedge clk); #1; @(posedge clk); #1; move_left = 0;

            move_right = 1; @(posedge clk); #1; @(posedge clk); #1; move_right = 0;

            move_left = 1; @(posedge clk); #1 move_left = 0;

            move_right = 1; @(posedge clk); #1 move_right = 0;

            move_left = 1; @(posedge clk); #1 move_left = 0;

            #1;


            check_outputs(16'h0065);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dfs Testbench");
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
        input [15:0] expected_path;
        begin
            if (expected_path === (expected_path ^ path ^ expected_path)) begin
                $display("PASS");
                $display("  Outputs: path=%h",
                         path);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: path=%h",
                         expected_path);
                $display("  Got:      path=%h",
                         path);
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
        $dumpvars(0,clk, move_left, move_right, node_value, reset, path);
    end

endmodule
