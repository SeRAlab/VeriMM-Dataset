`timescale 1ns/1ps

module qam_modulator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [3:0] symbol;
    wire [3:0] I;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    qam_modulator dut (
        .clk(clk),
        .reset(reset),
        .symbol(symbol),
        .I(I),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            symbol = 4'b0000;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Symbol 0000 -> (1, 1)", test_num);
            reset_dut();
            symbol = 4'b0000;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b0001, 4'b0001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Symbol 0001 -> (1, 3)", test_num);
            reset_dut();
            symbol = 4'b0001;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b0001, 4'b0011);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Symbol 0010 -> (3, 1)", test_num);
            reset_dut();
            symbol = 4'b0010;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b0011, 4'b0001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Symbol 0011 -> (3, 3)", test_num);
            reset_dut();
            symbol = 4'b0011;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b0011, 4'b0011);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Symbol 0100 -> (1, -1)", test_num);
            reset_dut();
            symbol = 4'b0100;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b0001, 4'b1111);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Symbol 0101 -> (1, -3)", test_num);
            reset_dut();
            symbol = 4'b0101;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b0001, 4'b1101);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Symbol 0110 -> (3, -1)", test_num);
            reset_dut();
            symbol = 4'b0110;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b0011, 4'b1111);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Symbol 0111 -> (3, -3)", test_num);
            reset_dut();
            symbol = 4'b0111;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b0011, 4'b1101);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Symbol 1000 -> (-1, 1)", test_num);
            reset_dut();
            symbol = 4'b1000;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b1111, 4'b0001);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Symbol 1001 -> (-1, 3)", test_num);
            reset_dut();
            symbol = 4'b1001;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b1111, 4'b0011);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Symbol 1010 -> (-3, 1)", test_num);
            reset_dut();
            symbol = 4'b1010;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b1101, 4'b0001);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Symbol 1011 -> (-3, 3)", test_num);
            reset_dut();
            symbol = 4'b1011;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b1101, 4'b0011);
        end
        endtask

    task testcase013;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Symbol 1100 -> (-1, -1)", test_num);
            reset_dut();
            symbol = 4'b1100;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b1111, 4'b1111);
        end
        endtask

    task testcase014;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Symbol 1101 -> (-1, -3)", test_num);
            reset_dut();
            symbol = 4'b1101;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b1111, 4'b1101);
        end
        endtask

    task testcase015;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Symbol 1110 -> (-3, -1)", test_num);
            reset_dut();
            symbol = 4'b1110;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b1101, 4'b1111);
        end
        endtask

    task testcase016;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Symbol 1111 -> (-3, -3)", test_num);
            reset_dut();
            symbol = 4'b1111;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b1101, 4'b1101);
        end
        endtask

    task testcase017;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset verification", test_num);

            reset = 0;
            symbol = 4'b0011;
            @(posedge clk);
            #1;

            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000, 4'b0000);
            reset = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("qam_modulator Testbench");
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
        testcase017();
        
        
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
        input [3:0] expected_I;
        input [3:0] expected_Q;
        begin
            if (expected_I === (expected_I ^ I ^ expected_I) &&
                expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: I=%h, Q=%h",
                         I, Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: I=%h, Q=%h",
                         expected_I, expected_Q);
                $display("  Got:      I=%h, Q=%h",
                         I, Q);
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
        $dumpvars(0,clk, reset, symbol, I, Q);
    end

endmodule
