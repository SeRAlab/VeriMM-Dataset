`timescale 1ns/1ps

module sparc_exu_rml_inc3_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] din;
    reg inc;
    wire [2:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sparc_exu_rml_inc3 dut (
        .din(din),
        .inc(inc),
        .dout(dout)
    );
    task testcase001;

    begin
        test_num = 1;
        din = 3'b000; inc = 1'b0;
        $display("Test %0d: din=0, inc=0", test_num);
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        din = 3'b001; inc = 1'b0;
        $display("Test %0d: din=1, inc=0", test_num);
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        din = 3'b010; inc = 1'b0;
        $display("Test %0d: din=2, inc=0", test_num);
        #1;

        check_outputs(3'b011);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        din = 3'b011; inc = 1'b0;
        $display("Test %0d: din=3, inc=0", test_num);
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        din = 3'b100; inc = 1'b0;
        $display("Test %0d: din=4, inc=0", test_num);
        #1;

        check_outputs(3'b101);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        din = 3'b101; inc = 1'b0;
        $display("Test %0d: din=5, inc=0", test_num);
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        din = 3'b110; inc = 1'b0;
        $display("Test %0d: din=6, inc=0", test_num);
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        din = 3'b111; inc = 1'b0;
        $display("Test %0d: din=7, inc=0", test_num);
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        din = 3'b000; inc = 1'b1;
        $display("Test %0d: din=0, inc=1", test_num);
        #1;

        check_outputs(3'b011);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        din = 3'b001; inc = 1'b1;
        $display("Test %0d: din=1, inc=1", test_num);
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        din = 3'b010; inc = 1'b1;
        $display("Test %0d: din=2, inc=1", test_num);
        #1;

        check_outputs(3'b101);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        din = 3'b011; inc = 1'b1;
        $display("Test %0d: din=3, inc=1", test_num);
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        din = 3'b100; inc = 1'b1;
        $display("Test %0d: din=4, inc=1", test_num);
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        din = 3'b101; inc = 1'b1;
        $display("Test %0d: din=5, inc=1", test_num);
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        din = 3'b110; inc = 1'b1;
        $display("Test %0d: din=6, inc=1", test_num);
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        din = 3'b111; inc = 1'b1;
        $display("Test %0d: din=7, inc=1", test_num);
        #1;

        check_outputs(3'b010);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sparc_exu_rml_inc3 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input [2:0] expected_dout;
        begin
            #1; // Small delay for combinational logic to settle
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

endmodule
