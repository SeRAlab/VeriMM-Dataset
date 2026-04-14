`timescale 1ns/1ps

module aes_sbox_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] in_data;
    reg rst;
    wire [3:0] out_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_sbox dut (
        .clk(clk),
        .in_data(in_data),
        .rst(rst),
        .out_data(out_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            in_data = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            in_data = 4'h0;
            @(posedge clk);
            #1;
            $display("Testcase %03d: Input 4'h0", test_num);
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            in_data = 4'h1;
            @(posedge clk);
            #1;
            $display("Testcase %03d: Input 4'h1", test_num);
            #1;

            check_outputs(4'h4);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            in_data = 4'h2;
            @(posedge clk);
            #1;
            $display("Testcase %03d: Input 4'h2", test_num);
            #1;

            check_outputs(4'hD);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            in_data = 4'h3;
            @(posedge clk);
            #1;
            $display("Testcase %03d: Input 4'h3", test_num);
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            in_data = 4'h4;
            @(posedge clk);
            #1;
            $display("Testcase %03d: Input 4'h4", test_num);
            #1;

            check_outputs(4'h2);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            in_data = 4'h5;
            @(posedge clk);
            #1;
            $display("Testcase %03d: Input 4'h5", test_num);
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            in_data = 4'h6;
            @(posedge clk);
            #1;
            $display("Testcase %03d: Input 4'h6", test_num);
            #1;

            check_outputs(4'hB);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            in_data = 4'h7;
            @(posedge clk);
            #1;
            $display("Testcase %03d: Input 4'h7", test_num);
            #1;

            check_outputs(4'h8);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            reset_dut();
            in_data = 4'h8;
            @(posedge clk);
            #1;
            $display("Testcase %03d: Input 4'h8", test_num);
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            reset_dut();
            in_data = 4'h9;
            @(posedge clk);
            #1;
            $display("Testcase %03d: Input 4'h9", test_num);
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            reset_dut();
            in_data = 4'hA;
            @(posedge clk);
            #1;
            $display("Testcase %03d: Input 4'hA", test_num);
            #1;

            check_outputs(4'h6);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            reset_dut();
            in_data = 4'hB;
            @(posedge clk);
            #1;
            $display("Testcase %03d: Input 4'hB", test_num);
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase013;

        begin
            test_num = test_num + 1;
            reset_dut();
            in_data = 4'hC;
            @(posedge clk);
            #1;
            $display("Testcase %03d: Input 4'hC", test_num);
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase014;

        begin
            test_num = test_num + 1;
            reset_dut();
            in_data = 4'hD;
            @(posedge clk);
            #1;
            $display("Testcase %03d: Input 4'hD", test_num);
            #1;

            check_outputs(4'h9);
        end
        endtask

    task testcase015;

        begin
            test_num = test_num + 1;
            reset_dut();
            in_data = 4'hE;
            @(posedge clk);
            #1;
            $display("Testcase %03d: Input 4'hE", test_num);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase016;

        begin
            test_num = test_num + 1;
            reset_dut();
            in_data = 4'hF;
            @(posedge clk);
            #1;
            $display("Testcase %03d: Input 4'hF", test_num);
            #1;

            check_outputs(4'h7);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_sbox Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input [3:0] expected_out_data;
        begin
            if (expected_out_data === (expected_out_data ^ out_data ^ expected_out_data)) begin
                $display("PASS");
                $display("  Outputs: out_data=%h",
                         out_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_data=%h",
                         expected_out_data);
                $display("  Got:      out_data=%h",
                         out_data);
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
        $dumpvars(0,clk, in_data, rst, out_data);
    end

endmodule
