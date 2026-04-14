`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr;
    reg clk;
    reg [15:0] din;
    reg we;
    wire [15:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .addr(addr),
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
            @(negedge clk);
            we = 0;
            addr = 0;
            din = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic write and read at address 0");
            test_num = test_num + 1;
            reset_dut();


            addr = 4'h0;
            din = 16'hAAAA;
            we = 1;
            @(negedge clk);


            we = 0;
            @(negedge clk);
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Write and read at address 15");
            test_num = test_num + 1;
            reset_dut();


            addr = 4'hF;
            din = 16'h5555;
            we = 1;
            @(negedge clk);


            we = 0;
            @(negedge clk);
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Verify Write Enable (we) functionality");
            test_num = test_num + 1;
            reset_dut();


            addr = 4'h5;
            din = 16'h1234;
            we = 1;
            @(negedge clk);


            we = 0;
            din = 16'hFFFF;
            @(negedge clk);


            #1;



            check_outputs(16'h1234);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Overwriting data at address 8");
            test_num = test_num + 1;
            reset_dut();


            addr = 4'h8;
            din = 16'h1111;
            we = 1;
            @(negedge clk);


            din = 16'h2222;
            @(negedge clk);


            we = 0;
            @(negedge clk);
            #1;

            check_outputs(16'h2222);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Data persistence across address space");
            test_num = test_num + 1;
            reset_dut();


            addr = 4'h2;
            din = 16'hC0DE;
            we = 1;
            @(negedge clk);


            addr = 4'h3;
            din = 16'hBEEF;
            we = 1;
            @(negedge clk);


            we = 0;
            addr = 4'h2;
            @(negedge clk);
            #1;

            check_outputs(16'hC0DE);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Write and read zero value");
            test_num = test_num + 1;
            reset_dut();

            addr = 4'hA;
            din = 16'h0000;
            we = 1;
            @(negedge clk);

            we = 0;
            @(negedge clk);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dram_cell Testbench");
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
        $dumpvars(0,addr, clk, din, we, dout);
    end

endmodule
