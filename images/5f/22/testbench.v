`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din;
    reg wemux;
    wire [7:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .wemux(wemux),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wemux = 0;
            din = 0;
            repeat(2) @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Shift in 0xA, Read Address 0", test_num);



            din = 8'hA0; wemux = 1;
            @(posedge clk);
            #2;


            wemux = 0;
            din = 8'h00;
            #5;
            #1;

            check_outputs(8'h0A);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Shift history check (Read Address 1)", test_num);


            din = 8'h50; wemux = 1;
            @(posedge clk);
            #2;


            din = 8'hA0; wemux = 1;
            @(posedge clk);
            #2;


            wemux = 0;
            din = 8'h01;
            #5;
            #1;

            check_outputs(8'h05);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Write Enable (wemux) functionality", test_num);


            din = 8'hC0; wemux = 1;
            @(posedge clk);
            #2;


            din = 8'hD0; wemux = 0;
            @(posedge clk);
            #2;


            din = 8'h00;
            #5;
            #1;

            check_outputs(8'h0C);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Address switching without clock", test_num);


            din = 8'h10; wemux = 1; @(posedge clk); #2;
            din = 8'h20; wemux = 1; @(posedge clk); #2;
            din = 8'h30; wemux = 1; @(posedge clk); #2;

            wemux = 0;

            din = 8'h00; #2;
            if (dout[3:0] !== 4'h3) begin
                $display("Subtest A failed");
            end


            din = 8'h02; #2;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase005;

        integer i;
        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Maximum depth access (Address 31)", test_num);


            din = 8'hF0; wemux = 1; @(posedge clk); #2;
            din = 8'h00; wemux = 1;
            for(i=0; i<31; i=i+1) begin
                @(posedge clk);
                #2;
            end


            wemux = 0;
            din = 8'h1F;
            #5;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [7:0] expected_dout;
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
        $dumpvars(0,clk, din, wemux, dout);
    end

endmodule
