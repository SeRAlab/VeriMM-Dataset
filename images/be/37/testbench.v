`timescale 1ns/1ps

module shift_reg_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [7:0] pi;
    reg rst_n;
    reg si;
    wire [7:0] po;
    wire so;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_reg_8bit dut (
        .clk(clk),
        .load(load),
        .pi(pi),
        .rst_n(rst_n),
        .si(si),
        .po(po),
        .so(so)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            load = 0;
            pi = 8'h00;
            si = 0;
            #20;
            rst_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Verify Reset State", test_num);
            reset_dut();

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Parallel Load (0xA5)", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            pi = 8'hA5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Test %0d: Shift in 4 '1's", test_num);
            reset_dut();
            @(negedge clk);
            load = 0;
            si = 1;

            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(8'h0F, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Verify SO bit propagation", test_num);
            reset_dut();

            @(negedge clk);
            load = 1;
            pi = 8'h80;
            @(posedge clk);

            @(negedge clk);
            load = 0;
            si = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Test %0d: Full 8-bit shift through", test_num);
            reset_dut();

            @(negedge clk);
            load = 0;
            for(i=0; i<8; i=i+1) begin
                si = (i % 2 == 0) ? 1 : 0;
                @(posedge clk);
            end
            #1;




            #1;





            check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Load signal priority over shifting", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            pi = 8'hFF;
            si = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Shift from loaded state 0x55", test_num);
            reset_dut();

            @(negedge clk);
            load = 1;
            pi = 8'h55;
            @(posedge clk);

            @(negedge clk);
            load = 0;
            si = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hAA, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_reg_8bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [7:0] expected_po;
        input expected_so;
        begin
            if (expected_po === (expected_po ^ po ^ expected_po) &&
                expected_so === (expected_so ^ so ^ expected_so)) begin
                $display("PASS");
                $display("  Outputs: po=%h, so=%b",
                         po, so);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: po=%h, so=%b",
                         expected_po, expected_so);
                $display("  Got:      po=%h, so=%b",
                         po, so);
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
        $dumpvars(0,clk, load, pi, rst_n, si, po, so);
    end

endmodule
