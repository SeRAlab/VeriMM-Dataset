`timescale 1ns/1ps

module dual_port_ram_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr_rd;
    reg [7:0] addr_wr;
    reg clk;
    reg [7:0] data_wr;
    reg we;
    wire [7:0] data_rd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dual_port_ram dut (
        .addr_rd(addr_rd),
        .addr_wr(addr_wr),
        .clk(clk),
        .data_wr(data_wr),
        .we(we),
        .data_rd(data_rd)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            addr_wr = 0;
            data_wr = 0;
            addr_rd = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Basic Write and Read");


            we = 1;
            addr_wr = 8'h05;
            data_wr = 8'hAA;
            @(posedge clk);
            #1;


            we = 0;
            addr_rd = 8'h05;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Write Enable Verification");


            we = 1; addr_wr = 8'h10; data_wr = 8'hBE;
            @(posedge clk);
            #1;


            we = 0; addr_wr = 8'h10; data_wr = 8'h55;
            @(posedge clk);
            #1;


            addr_rd = 8'h10;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hBE);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Sequential Writes");

            we = 1;
            addr_wr = 8'h01; data_wr = 8'h11; @(posedge clk); #1;
            addr_wr = 8'h02; data_wr = 8'h22; @(posedge clk); #1;
            addr_wr = 8'h03; data_wr = 8'h33; @(posedge clk); #1;

            we = 0;
            addr_rd = 8'h02;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Overwriting Address");

            we = 1;
            addr_wr = 8'h20; data_wr = 8'hA1; @(posedge clk); #1;
            addr_wr = 8'h20; data_wr = 8'hB2; @(posedge clk); #1;

            we = 0;
            addr_rd = 8'h20;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hB2);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Simultaneous Read and Write");


            we = 1; addr_wr = 8'h40; data_wr = 8'h12; @(posedge clk); #1;


            we = 1;
            addr_wr = 8'h50;
            data_wr = 8'h34;
            addr_rd = 8'h40;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h12);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase 006: Boundary Address Check (255)");

            we = 1;
            addr_wr = 8'hFF;
            data_wr = 8'hFF;
            @(posedge clk);
            #1;

            we = 0;
            addr_rd = 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dual_port_ram Testbench");
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
        input [7:0] expected_data_rd;
        begin
            if (expected_data_rd === (expected_data_rd ^ data_rd ^ expected_data_rd)) begin
                $display("PASS");
                $display("  Outputs: data_rd=%h",
                         data_rd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_rd=%h",
                         expected_data_rd);
                $display("  Got:      data_rd=%h",
                         data_rd);
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
        $dumpvars(0,addr_rd, addr_wr, clk, data_wr, we, data_rd);
    end

endmodule
