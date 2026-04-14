`timescale 1ns/1ps

module PageTable_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] frame_num;
    reg [3:0] v_addr;
    reg we;
    wire [3:0] p_frame;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PageTable dut (
        .clk(clk),
        .frame_num(frame_num),
        .v_addr(v_addr),
        .we(we),
        .p_frame(p_frame)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            v_addr = 0;
            frame_num = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Basic Write and Read (Addr 3 -> Frame A)", test_num);

            v_addr = 4'h3;
            frame_num = 4'hA;
            we = 1;
            @(posedge clk);
            #1 we = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Overwrite Entry (Addr 7: 2 -> C)", test_num);


            v_addr = 4'h7; frame_num = 4'h2; we = 1;
            @(posedge clk);

            #1 frame_num = 4'hC;
            @(posedge clk);
            #1 we = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(4'hC);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Write Enable De-asserted Check", test_num);


            v_addr = 4'h5; frame_num = 4'h5; we = 1;
            @(posedge clk);

            #1 frame_num = 4'hF; we = 0;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(4'h5);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Lower Boundary (Addr 0)", test_num);

            v_addr = 4'h0; frame_num = 4'hF; we = 1;
            @(posedge clk);
            #1 we = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Upper Boundary (Addr 15)", test_num);

            v_addr = 4'hF; frame_num = 4'h1; we = 1;
            @(posedge clk);
            #1 we = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Address Isolation", test_num);


            v_addr = 4'h1; frame_num = 4'hB; we = 1;
            @(posedge clk);

            #1 v_addr = 4'h2; frame_num = 4'hC;
            @(posedge clk);
            #1 we = 0; v_addr = 4'h1;
            @(posedge clk);
            #1 #1;
 check_outputs(4'hB);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("PageTable Testbench");
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
        input [3:0] expected_p_frame;
        begin
            if (expected_p_frame === (expected_p_frame ^ p_frame ^ expected_p_frame)) begin
                $display("PASS");
                $display("  Outputs: p_frame=%h",
                         p_frame);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p_frame=%h",
                         expected_p_frame);
                $display("  Got:      p_frame=%h",
                         p_frame);
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
        $dumpvars(0,clk, frame_num, v_addr, we, p_frame);
    end

endmodule
