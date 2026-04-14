`timescale 1ns/1ps

module mem_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] addr;
    reg clk;
    reg [7:0] d_i;
    reg wr;
    wire [7:0] d_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mem dut (
        .addr(addr),
        .clk(clk),
        .d_i(d_i),
        .wr(wr),
        .d_o(d_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wr = 0;
            addr = 0;
            d_i = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %0d: Basic Write and Read at Addr 0", test_num);


            wr = 1;
            addr = 10'h000;
            d_i = 8'hAA;
            @(posedge clk);
            #1;


            wr = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %0d: Write and Read at Max Addr (1023)", test_num);

            wr = 1;
            addr = 10'h3FF;
            d_i = 8'h55;
            @(posedge clk);
            #1;

            wr = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %0d: Overwriting data at Addr 0x123", test_num);


            wr = 1;
            addr = 10'h123;
            d_i = 8'h11;
            @(posedge clk);
            #1;


            d_i = 8'h99;
            @(posedge clk);
            #1;

            wr = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h99);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %0d: Address Isolation Check", test_num);


            wr = 1;
            addr = 10'h010;
            d_i = 8'hBE;
            @(posedge clk);
            #1;


            addr = 10'h011;
            d_i = 8'hEF;
            @(posedge clk);
            #1;


            wr = 0;
            addr = 10'h010;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hBE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %0d: Read latency check", test_num);


            wr = 1;
            addr = 10'h050;
            d_i = 8'hCC;
            @(posedge clk);
            #1;



            wr = 0;
            addr = 10'h000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hCC);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mem Testbench");
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
        input [7:0] expected_d_o;
        begin
            if (expected_d_o === (expected_d_o ^ d_o ^ expected_d_o)) begin
                $display("PASS");
                $display("  Outputs: d_o=%h",
                         d_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d_o=%h",
                         expected_d_o);
                $display("  Got:      d_o=%h",
                         d_o);
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
        $dumpvars(0,addr, clk, d_i, wr, d_o);
    end

endmodule
