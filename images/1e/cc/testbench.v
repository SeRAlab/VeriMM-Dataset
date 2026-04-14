`timescale 1ns/1ps

module pipeline_reg_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] in;
    wire [4:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_reg dut (
        .clk(clk),
        .in(in),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in <= 5'b0;

            repeat (8) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Propagation of 5'h0A", test_num);
            reset_dut();
            @(posedge clk);
            in <= 5'h0A;
            repeat (7) @(posedge clk);
            #1;
            #1;

            check_outputs(5'h0A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Propagation of maximum value 5'h1F", test_num);
            reset_dut();
            @(posedge clk);
            in <= 5'h1F;
            repeat (7) @(posedge clk);
            #1;
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Propagation of 5'h01", test_num);
            reset_dut();
            @(posedge clk);
            in <= 5'h01;
            repeat (7) @(posedge clk);
            #1;
            #1;

            check_outputs(5'h01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sequence check - 1st value in pipeline", test_num);
            reset_dut();
            @(posedge clk); in <= 5'h11;
            @(posedge clk); in <= 5'h12;
            @(posedge clk); in <= 5'h13;
            @(posedge clk); in <= 5'h14;
            @(posedge clk); in <= 5'h15;
            @(posedge clk); in <= 5'h16;
            @(posedge clk); in <= 5'h17;
            #1;
            #1;

            check_outputs(5'h11);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Propagation of 5'h00 after activity", test_num);
            reset_dut();

            @(posedge clk); in <= 5'h1F;
            repeat (7) @(posedge clk);

            @(posedge clk); in <= 5'h00;
            repeat (7) @(posedge clk);
            #1;
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Propagation of 5'h15 (10101)", test_num);
            reset_dut();
            @(posedge clk);
            in <= 5'h15;
            repeat (7) @(posedge clk);
            #1;
            #1;

            check_outputs(5'h15);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipeline_reg Testbench");
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
        input [4:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, in, out);
    end

endmodule
