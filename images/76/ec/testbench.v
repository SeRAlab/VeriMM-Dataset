`timescale 1ns/1ps

module dual_port_ram_32bit_8word_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg [2:0] rd_addr;
    reg [2:0] wr_addr;
    reg wr_en;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dual_port_ram_32bit_8word dut (
        .clk(clk),
        .data_in(data_in),
        .rd_addr(rd_addr),
        .wr_addr(wr_addr),
        .wr_en(wr_en),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wr_en = 0;
            wr_addr = 3'b0;
            rd_addr = 3'b0;
            data_in = 32'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Write and Read (Addr 0)", test_num);
            reset_dut();


            @(negedge clk);
            wr_addr = 3'd0;
            data_in = 32'hDEADBEEF;
            wr_en = 1;
            @(posedge clk);


            @(negedge clk);
            wr_en = 0;
            rd_addr = 3'd0;
            #2;

            #1;


            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write to Boundary Address (Addr 7)", test_num);
            reset_dut();

            @(negedge clk);
            wr_addr = 3'd7;
            data_in = 32'h12345678;
            wr_en = 1;
            @(posedge clk);

            @(negedge clk);
            wr_en = 0;
            rd_addr = 3'd7;
            #2;

            #1;


            check_outputs(32'h12345678);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Verify Write Enable low prevents writing", test_num);
            reset_dut();


            @(negedge clk);
            wr_addr = 3'd2;
            data_in = 32'hAAAA_AAAA;
            wr_en = 1;
            @(posedge clk);


            @(negedge clk);
            wr_addr = 3'd2;
            data_in = 32'h5555_5555;
            wr_en = 0;
            @(posedge clk);

            @(negedge clk);
            rd_addr = 3'd2;
            #2;


            #1;



            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Simultaneous Write (Addr 5) and Read (Addr 1)", test_num);
            reset_dut();


            @(negedge clk);
            wr_addr = 3'd1;
            data_in = 32'hBBBB_CCCC;
            wr_en = 1;
            @(posedge clk);


            @(negedge clk);
            wr_addr = 3'd5;
            data_in = 32'h1111_2222;
            wr_en = 1;
            rd_addr = 3'd1;
            @(posedge clk);

            #2;

            #1;


            check_outputs(32'hBBBB_CCCC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Memory Isolation Check", test_num);
            reset_dut();


            @(negedge clk);
            wr_addr = 3'd3;
            data_in = 32'h3333_3333;
            wr_en = 1;
            @(posedge clk);


            @(negedge clk);
            wr_addr = 3'd4;
            data_in = 32'h4444_4444;
            wr_en = 1;
            @(posedge clk);

            @(negedge clk);
            wr_en = 0;
            rd_addr = 3'd3;
            #2;


            #1;



            check_outputs(32'h3333_3333);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dual_port_ram_32bit_8word Testbench");
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
        input [31:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, rd_addr, wr_addr, wr_en, data_out);
    end

endmodule
