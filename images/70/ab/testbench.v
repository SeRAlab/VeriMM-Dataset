`timescale 1ns/1ps

module falling_edge_capturer_20bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [19:0] in;
    reg reset_n;
    wire [19:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    falling_edge_capturer_20bit dut (
        .clk(clk),
        .in(in),
        .reset_n(reset_n),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            in = 20'h0;
            @(negedge clk);
            reset_n = 1;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset and No Activity", test_num);
            reset_dut();

            @(posedge clk);
            #1;
            #1;

            check_outputs(20'h00000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single bit falling edge (Bit 0)", test_num);
            reset_dut();


            @(negedge clk);
            in = 20'h00001;
            @(posedge clk);


            @(negedge clk);
            in = 20'h00000;
            @(posedge clk);

            #1;
            #1;

            check_outputs(20'h00001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Multiple bits falling edge (0, 5, 10, 15)", test_num);
            reset_dut();


            @(negedge clk);
            in = 20'h84210;
            @(posedge clk);


            @(negedge clk);
            in = 20'h00000;
            @(posedge clk);

            #1;
            #1;

            check_outputs(20'h84210);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Rising edge (0 to 1) - Should not detect", test_num);
            reset_dut();


            @(negedge clk);
            in = 20'h00000;
            @(posedge clk);


            @(negedge clk);
            in = 20'hFFFFF;
            @(posedge clk);

            #1;
            #1;

            check_outputs(20'h00000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: All bits falling edge", test_num);
            reset_dut();

            @(negedge clk);
            in = 20'hFFFFF;
            @(posedge clk);

            @(negedge clk);
            in = 20'h00000;
            @(posedge clk);

            #1;
            #1;

            check_outputs(20'hFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Partial bits falling edge", test_num);
            reset_dut();


            @(negedge clk);
            in = 20'hAAAAA;
            @(posedge clk);


            @(negedge clk);
            in = 20'h55555;
            @(posedge clk);



            #1;
            #1;

            check_outputs(20'hAAAAA);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Steady state high (1 to 1)", test_num);
            reset_dut();

            @(negedge clk);
            in = 20'hFFFFF;
            @(posedge clk);

            @(negedge clk);
            in = 20'hFFFFF;
            @(posedge clk);

            #1;
            #1;

            check_outputs(20'h00000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("falling_edge_capturer_20bit Testbench");
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
        input [19:0] expected_out;
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
        $dumpvars(0,clk, in, reset_n, out);
    end

endmodule
