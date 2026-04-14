`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] din;
    reg we;
    wire [15:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .clk(clk),
        .din(din),
        .we(we),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin


            we <= 1;
            din <= 16'h0000;
            @(posedge clk);
            #1;
            we <= 0;
            din <= 16'hzzzz;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write/Read (0xAAAA)", test_num);
            reset_dut();


            we <= 1;
            din <= 16'hAAAA;
            @(posedge clk);
            #1;


            we <= 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Persistence with we=0", test_num);
            reset_dut();


            we <= 1;
            din <= 16'h5555;
            @(posedge clk);
            #1;


            we <= 0;
            din <= 16'hFFFF;
            @(posedge clk);
            #1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write all ones (0xFFFF)", test_num);
            reset_dut();

            we <= 1;
            din <= 16'hFFFF;
            @(posedge clk);
            #1;

            we <= 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write all zeros (0x0000)", test_num);
            reset_dut();


            we <= 1;
            din <= 16'h1234;
            @(posedge clk);
            #1;


            we <= 1;
            din <= 16'h0000;
            @(posedge clk);
            #1;

            we <= 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Consecutive Writes", test_num);
            reset_dut();


            we <= 1;
            din <= 16'h1111;
            @(posedge clk);
            #1;
            din <= 16'h2222;
            @(posedge clk);
            #1;
            din <= 16'h3333;
            @(posedge clk);
            #1;

            we <= 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h3333);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Clock Edge Sensitivity Check", test_num);
            reset_dut();

            we <= 1;
            din <= 16'hBEEF;
            #2;
            din <= 16'hCAFE;
            @(posedge clk);
            #1;

            we <= 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hCAFE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sram_cell Testbench");
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
        input [15:0] expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
        $dumpvars(0,clk, din, we, dout);
    end

endmodule
