`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] d;
    reg href;
    reg pclk;
    reg vsync;
    wire [16:0] addr;
    wire [15:0] dout;
    wire we;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d(d),
        .href(href),
        .pclk(pclk),
        .vsync(vsync),
        .addr(addr),
        .dout(dout),
        .we(we)
    );

    // Clock generation (10ns period)
    initial begin
        pclk = 0;
        forever #5 pclk = ~pclk;
    end

        task reset_dut;

        begin
            vsync = 0;
            href = 0;
            d = 8'h00;
            repeat(2) @(posedge pclk);
            vsync = 1;
            repeat(5) @(posedge pclk);
            vsync = 0;
            repeat(2) @(posedge pclk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            @(posedge pclk);
            href = 1; d = 8'hA5;
            @(posedge pclk);
            href = 1; d = 8'h5A;

            @(posedge pclk);
            #1;



            #1;




            check_outputs(17'd0, 16'hA55A, 1'b1);

            href = 0;
            repeat(2) @(posedge pclk);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            @(posedge pclk); href = 1; d = 8'h11;
            @(posedge pclk); href = 1; d = 8'h22;

            @(posedge pclk); href = 1; d = 8'h33;
            @(posedge pclk); href = 1; d = 8'h44;

            @(posedge pclk);
            #1;


            #1;



            check_outputs(17'd1, 16'h3344, 1'b1);

            href = 0;
            repeat(2) @(posedge pclk);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            @(posedge pclk); href = 1; d = 8'hBC;
            @(posedge pclk); href = 0; d = 8'hFF;
            @(posedge pclk); href = 0; d = 8'h00;
            @(posedge pclk); href = 1; d = 8'hDE;

            @(posedge pclk);
            #1;

            #1;


            check_outputs(17'd0, 16'hBCDE, 1'b1);

            href = 0;
            repeat(2) @(posedge pclk);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            @(posedge pclk);
            href = 1; d = 8'h12;

            @(posedge pclk);
            #1;

            if (we === 1'b0) begin
                $display("PASS: WE is low after 1st byte");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: WE is high after only 1st byte");
                fail_count = fail_count + 1;
            end

            href = 0;
            repeat(2) @(posedge pclk);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            repeat(2) begin
                @(posedge pclk); href = 1; d = 8'hAA;
                @(posedge pclk); href = 1; d = 8'hBB;
            end


            @(posedge pclk); vsync = 1;
            @(posedge pclk); vsync = 0;


            @(posedge pclk); href = 1; d = 8'hCC;
            @(posedge pclk); href = 1; d = 8'hDD;

            @(posedge pclk);
            #1;

            #1;


            check_outputs(17'd0, 16'hCCDD, 1'b1);

            href = 0;
            repeat(2) @(posedge pclk);
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
        input [16:0] expected_addr;
        input [15:0] expected_dout;
        input expected_we;
        begin
            if (expected_addr === (expected_addr ^ addr ^ expected_addr) &&
                expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_we === (expected_we ^ we ^ expected_we)) begin
                $display("PASS");
                $display("  Outputs: addr=%h, dout=%h, we=%b",
                         addr, dout, we);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addr=%h, dout=%h, we=%b",
                         expected_addr, expected_dout, expected_we);
                $display("  Got:      addr=%h, dout=%h, we=%b",
                         addr, dout, we);
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
        $dumpvars(0,d, href, pclk, vsync, addr, dout, we);
    end

endmodule
