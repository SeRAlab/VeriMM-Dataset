`timescale 1ns/1ps

module dual_port_ram_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [5:0] rd_addr;
    reg [5:0] wr_addr;
    reg [15:0] wr_data;
    reg wr_en;
    wire [15:0] rd_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dual_port_ram dut (
        .clk(clk),
        .rd_addr(rd_addr),
        .wr_addr(wr_addr),
        .wr_data(wr_data),
        .wr_en(wr_en),
        .rd_data(rd_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wr_en = 0;
            wr_addr = 0;
            wr_data = 0;
            rd_addr = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Write and Read", test_num);
            reset_dut();


            wr_en = 1;
            wr_addr = 6'd10;
            wr_data = 16'hABCD;
            @(posedge clk);
            #1;


            wr_en = 0;
            rd_addr = 6'd10;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Addresses (0 and 63)", test_num);
            reset_dut();


            wr_en = 1; wr_addr = 6'd0; wr_data = 16'h1111;
            @(posedge clk);
            #1;


            wr_en = 1; wr_addr = 6'd63; wr_data = 16'hFFFF;
            @(posedge clk);
            #1;


            wr_en = 0;
            rd_addr = 6'd63;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Write Enable Verification", test_num);
            reset_dut();


            wr_en = 1; wr_addr = 6'd5; wr_data = 16'h5555;
            @(posedge clk);
            #1;


            wr_en = 0; wr_addr = 6'd5; wr_data = 16'hAAAA;
            @(posedge clk);
            #1;


            rd_addr = 6'd5;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h5555);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simultaneous Read and Write", test_num);
            reset_dut();


            wr_en = 1; wr_addr = 6'd20; wr_data = 16'h2020;
            @(posedge clk);
            #1;


            wr_en = 1; wr_addr = 6'd30; wr_data = 16'h3030;
            rd_addr = 6'd20;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h2020);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data Overwrite", test_num);
            reset_dut();


            wr_en = 1; wr_addr = 6'd42; wr_data = 16'h0001;
            @(posedge clk);
            #1;


            wr_en = 1; wr_addr = 6'd42; wr_data = 16'h8000;
            @(posedge clk);
            #1;


            wr_en = 0; rd_addr = 6'd42;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h8000);
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
        input [15:0] expected_rd_data;
        begin
            if (expected_rd_data === (expected_rd_data ^ rd_data ^ expected_rd_data)) begin
                $display("PASS");
                $display("  Outputs: rd_data=%h",
                         rd_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd_data=%h",
                         expected_rd_data);
                $display("  Got:      rd_data=%h",
                         rd_data);
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
        $dumpvars(0,clk, rd_addr, wr_addr, wr_data, wr_en, rd_data);
    end

endmodule
