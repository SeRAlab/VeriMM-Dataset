`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] s422_data;
    reg s422_de;
    reg [15:0] s422_sync;
    wire [23:0] s444_data;
    wire [15:0] s444_sync;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .s422_data(s422_data),
        .s422_de(s422_de),
        .s422_sync(s422_sync),
        .s444_data(s444_data),
        .s444_sync(s444_sync)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            s422_data <= 16'h0;
            s422_de <= 1'b0;
            s422_sync <= 16'h0;
            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic 4:2:2 to 4:4:4 conversion...");
            reset_dut();
            test_num = test_num + 1;

            @(posedge clk);
            s422_de <= 1'b1;
            s422_sync <= 16'hAAAA;
            s422_data <= {8'hCB, 8'h10};

            @(posedge clk);
            s422_de <= 1'b1;
            s422_sync <= 16'h5555;
            s422_data <= {8'hCR, 8'h11};

            @(posedge clk);
            s422_de <= 1'b0;
            s422_sync <= 16'h0;


            repeat(3) @(posedge clk);




            #1;





            check_outputs(24'hCRCB11, 16'h5555);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Continuous stream processing...");
            reset_dut();
            test_num = test_num + 1;

            @(posedge clk);
            s422_de <= 1'b1;
            s422_sync <= 16'h0001;
            s422_data <= 16'h11AA;

            @(posedge clk);
            s422_sync <= 16'h0002;
            s422_data <= 16'h22BB;

            @(posedge clk);
            s422_sync <= 16'h0003;
            s422_data <= 16'h33CC;

            @(posedge clk);
            s422_sync <= 16'h0004;
            s422_data <= 16'h44DD;

            @(posedge clk);
            s422_de <= 1'b0;

            repeat(2) @(posedge clk);



            #1;




            check_outputs(24'h4433DD, 16'h0004);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Data Enable and Sync logic...");
            reset_dut();
            test_num = test_num + 1;


            @(posedge clk);
            s422_de <= 1'b1;
            s422_sync <= 16'hFFFF;
            s422_data <= 16'hFFee;


            @(posedge clk);
            s422_de <= 1'b0;
            s422_sync <= 16'h0000;
            s422_data <= 16'h0000;

            repeat(5) @(posedge clk);



            #1;




            check_outputs(24'h000000, 16'h0000);
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
        input [23:0] expected_s444_data;
        input [15:0] expected_s444_sync;
        begin
            if (expected_s444_data === (expected_s444_data ^ s444_data ^ expected_s444_data) &&
                expected_s444_sync === (expected_s444_sync ^ s444_sync ^ expected_s444_sync)) begin
                $display("PASS");
                $display("  Outputs: s444_data=%h, s444_sync=%h",
                         s444_data, s444_sync);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: s444_data=%h, s444_sync=%h",
                         expected_s444_data, expected_s444_sync);
                $display("  Got:      s444_data=%h, s444_sync=%h",
                         s444_data, s444_sync);
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
        $dumpvars(0,clk, s422_data, s422_de, s422_sync, s444_data, s444_sync);
    end

endmodule
