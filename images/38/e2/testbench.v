`timescale 1ns/1ps

module MMU_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] virtual_address;
    reg we;
    wire [15:0] physical_address;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    MMU dut (
        .clk(clk),
        .virtual_address(virtual_address),
        .we(we),
        .physical_address(physical_address),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            virtual_address = 16'h0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Write Mapping (VPN 0x0A -> PPN 0x55) and Read", test_num);
            reset_dut();



            virtual_address = 16'h0A55;
            we = 1;
            @(posedge clk);
            #1;


            we = 0;
            virtual_address = 16'h0A05;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h5505, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Write Mapping (VPN 0xF0 -> PPN 0x0F) and Read", test_num);
            reset_dut();


            virtual_address = 16'hF00F;
            we = 1;
            @(posedge clk);
            #1;


            we = 0;
            virtual_address = 16'hF0AA;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0FAA, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Access Unmapped Address", test_num);
            reset_dut();


            we = 0;
            virtual_address = 16'hEE00;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h0000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Overwrite Mapping (VPN 0x0A -> PPN 0x77)", test_num);
            reset_dut();


            virtual_address = 16'h0A77;
            we = 1;
            @(posedge clk);
            #1;


            we = 0;
            virtual_address = 16'h0A12;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h7712, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Boundary Page VPN 0xFF", test_num);
            reset_dut();


            virtual_address = 16'hFF88;
            we = 1;
            @(posedge clk);
            #1;

            we = 0;
            virtual_address = 16'hFFFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h88FF, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("MMU Testbench");
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
        input [15:0] expected_physical_address;
        input expected_valid;
        begin
            if (expected_physical_address === (expected_physical_address ^ physical_address ^ expected_physical_address) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: physical_address=%h, valid=%b",
                         physical_address, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: physical_address=%h, valid=%b",
                         expected_physical_address, expected_valid);
                $display("  Got:      physical_address=%h, valid=%b",
                         physical_address, valid);
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
        $dumpvars(0,clk, virtual_address, we, physical_address, valid);
    end

endmodule
